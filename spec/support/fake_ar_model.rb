# This exists so one is able to mock actual ActiveRecord model classes that are
# not tied to a database. This is useful if you want to write tests for concerns
# without tying them to project-specific models.
#
# * It allows you to not mock simple ActiveRecord DSL like find/find_by/where
#   calls.
# * Projects using Plok can also use this, provided they call
#   Plok::Engine.load_spec_supports in their spec/rails_helper.rb file.
# * Even if you're required to mock additional business logic onto your classes,
#   you can just extend from Plok::FakeArModel to fill in gaps.
#
#   Example:
#
#     class Product < Plok::FakeArModel
#       def visible?
#         true
#       end
#
#       def hidden?
#         !visible?
#       end
#     end
#
class Plok::FakeArModel
  extend  ActiveModel::Naming
  extend  ActiveModel::Translation
  include ActiveModel::Validations
  include ActiveModel::Conversion
  include ActiveModel::Dirty

  def initialize(attributes = {})
    attributes.each do |key, value|
      instance_variable_set(:"@#{key}", value)
      self.class.send(:attr_accessor, key)
    end
  end

  def self.collection(list)
    @collection = list.to_a.map { |values| new(values) }
  end

  def self.primary_key
    :id
  end

  def self.polymorphic_name
    :fake_ar_modelable
  end

  def self.current_scope
  end

  def self.find(id)
    @collection.to_a.detect { |o| o.id == id }
  end

  def self.find_by(arguments)
    where(arguments)&.first
  end

  def self.where(arguments = nil)
    @collection.select do |o|
      if arguments.is_a?(Hash)
        !!arguments.detect { |k, v| o.send(k) == v }
      elsif(arguments.is_a?(String))
        # NOTE: This will require intensive tinkering if we ever need it,
        # so lets leave it for now.
        []
      end
    end
  end

  def destroyed?
    false
  end

  def new_record?
    true
  end

  def save(options = {})
    true
  end

  def _read_attribute(a)
    a
  end

  private

  def collection
    self.class.instance_variable_get(:@collection)&.to_a || []
  end

end
