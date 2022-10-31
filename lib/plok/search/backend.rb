# Due to the load order of classes, Backend precedes the required Base class.
require_relative 'base'

module Plok::Search
  # The goal of this class is to provide a manipulated version of the filtered
  # index data that we can use in the result set of an autocomplete-triggered
  # search query. See Plok::Search::Base for more information on how this
  # search functionality is designed.
  class Backend < Plok::Search::Base
    # This translates the filtered indices into meaningful result objects.
    #
    # #search_indices will return a list of SearchIndex records.
    # #format_search_results will return a list of jquery-ui friendly hashes:
    #
    # [
    #   { label: ... value: ... },
    #   { label: ... value: ... }
    # ]
    #
    def search(modules: [])
      format_search_results(search_indices(modules: modules))
    end
  end
end
