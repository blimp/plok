module Plok
  class InterfaceNotImplementedError < NoMethodError
  end

  class Search::ResultObjects::Base
    attr_reader :index, :search_context

    delegate :searchable, to: :index

    def initialize(index, search_context: nil)
      @index = index
      @search_context = search_context
    end

    # Typically, an autocomplete requires 3 things:
    #
    # * A title indicating a resource name.
    #   Examples: Page#title, Product#name,...
    # * A truncated summary providing a glimpse of the resource's contents.
    #   Examples: Page#subtitle, Product#description,...
    # * A link to the resource.
    #   Examples: edit_backend_page_path(37), product_path(37),...
    #
    # However, this seems very restrictive to me. If I narrow down the data
    # a dev can use in an autocomplete, it severely reduces options he/she has
    # in how the autocomplete results look like. Think of autocompletes in a
    # shop that require images or prices to be included in their result bodies.
    #
    # This is why I chose to let ApplicationController.render work around the
    # problem by letting the dev decide how the row should look.
    #
    def build_html
      ApplicationController.render(partial: partial, locals: locals)
    end

    def hidden?
      searchable.respond_to?(:visible?) && searchable.hidden?
    end

    def label
      # We want to grab the name of the index from ContentText whenever
      # we're dealing with FlexibleContent stuff.
      if index.name.include?('flexible_content')
        id = index.name.split(':')[1].to_i
        return ContentText.find(id).content
      end

      searchable.send(index.name)
    end

    def locals
      { "#{partial_target}": index.searchable, index: index }
    end

    def namespace
      search_context.namespace.to_s.underscore
    end

    def partial
      "#{partial_path}/#{partial_target}"
    end

    def partial_path
      # TODO: This is a fallback for older Plok versions whose result object
      # partials still reside in app/views/backens/search/*. Best to remove
      # this at a later stage, but for now they can be backwards compatible.
      if File.exist?("app/views/#{namespace}/search/_#{partial_target}.html.erb")
        return "#{namespace}/search"
      end

      "plok/search/result_objects/#{namespace}"
    end

    def partial_target
      index.searchable_type.underscore
    end

    def unpublished?
      searchable.respond_to?(:published?) && searchable.unpublished?
    end

    def url
    end
  end
end
