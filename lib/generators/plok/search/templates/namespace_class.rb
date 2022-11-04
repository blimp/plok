module Plok::Search
  # The reason this class exists is mainly to provide a context layer to
  # override Plok::Search::Base. It provides a manipulated version of the
  # filtered index data that we can use in the result set of an
  # autocomplete-triggered search query.
  class [namespace] < Plok::Search::Base
    # This translates the filtered indices into meaningful result objects.
    #
    # #search_indices will return an ActiveRecord::Relation of SearchIndex
    # records. Because #lazy is chained after it, we still have a way to fiddle
    # with the AR query when necessary.
    #
    # #format_search_results will return a list of jquery-ui friendly hashes:
    #   [
    #     { label: ... value: ... },
    #     { label: ... value: ... }
    #   ]
    #
    def search(modules: [])
      format_search_results(
        search_indices(modules: modules).lazy
      )
    end
  end
end
