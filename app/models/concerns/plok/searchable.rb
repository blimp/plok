# TODO: Find a way to spec this properly.
module Plok::Searchable
  extend ActiveSupport::Concern

  included do
    has_many :search_indices, as: :searchable

    # The after_save block creates or saves indices for every indicated
    # searchable field. Takes both translations and flexible content into
    # account.
    #
    # Translation support was relatively painless, but FlexibleContent
    # required more thought. See #save_flexible_content_indices!
    after_save do
      trigger_indices_save!
    end

    def trigger_indices_save!
      self.class.searchable_fields_list.each do |namespace, keys|
        keys.each do |key|
          if key == :flexible_content
            save_flexible_content_search_indices!(namespace) && next
          end

          if respond_to?(:translatable?) && self.class.translatable_fields_list.include?(key)
            save_translatable_search_index!(namespace, key) && next
          end

          save_search_index!(namespace, key)
        end
      end
    end

    # I save all ContentText#content values as indices linked to the parent
    # object. The Plok::Search::Base#indices method already groups by
    # searchable resource, so there are never any duplicates.
    # Only additional matches for the searchable because it takes
    # ContentText#content sources into account.
    #
    # ContentColumn and ContentText have after_{save,destroy} callbacks
    # to help facilitate searchable management. Note that said code was
    # initially present in this class, and it was such a mess that it became
    # unpractical to maintain.
    def save_flexible_content_search_indices!(namespace)
      content_rows.each do |row|
        row.columns.each do |column|
          next unless column.content.is_a?(ContentText)
          key = "flexible_content:#{column.content_id}"
          save_search_index!(namespace, key, value: column.content.content, locale: row.locale)
        end
      end
    end

    def save_search_index!(namespace, key, value: nil, locale: nil)
      value = if value.present?
                value
              elsif ActiveRecord::Base.connection.column_exists?(self.class.table_name, key)
                read_attribute(key)
              elsif respond_to?(key)
                send(key)
              end

      return if value.blank?

      search_indices
        .find_or_create_by!(namespace: namespace, name: key, locale: locale)
        .update_column(:value, value)
    end

    def save_translatable_search_index!(namespace, key)
      # TODO: locales can't be hardcoded
      %w(nl fr).each do |locale|
        value = translation(locale.to_sym).send(key)
        save_search_index!(namespace, key, value: value, locale: locale)
      end
    end

    def searchable?
      true
    end
  end

  module ClassMethods
    def searchable_field(namespace, key)
      return if searchable_fields_list.dig(namespace.to_sym)&.include?(key.to_sym)

      if searchable_fields_list[namespace.to_sym].blank?
        searchable_fields_list[namespace.to_sym] = []
      end

      searchable_fields_list[namespace.to_sym] << key.to_sym
    end

    def plok_searchable(namespace: nil, fields: [], conditions: [])
      fields.each { |key| searchable_field(namespace, key) }
    end

    def searchable_fields_list
      @searchable_fields_list ||= {}
    end
  end
end
