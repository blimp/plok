# Due to the load order of classes, Backend precedes the required Base class.
require_relative 'base'

module Plok::Search
  # The goal of this class is to provide a manipulated version of the filtered
  # index data that we can use in the result set of an autocomplete-triggered
  # search query. See Plok::Search::Base for more information on how this
  # search functionality is designed.
  class Backend < Plok::Search::Base
    # This translates the filtered indices into meaningful result objects.
    # These require a { label: ... value: ... } to accommodate jquery-ui.
    #
    # Note that the result_object#url method is defined in
    # Plok::Search::ResultObjects::Backend::Page.
    #
    # TODO: Make this able to pass a list of searchable modules.
    def search
      indices.map do |index|
        result = result_object(index)
        { label: result.build_html, value: result.url }
      end
    end
  end
end
