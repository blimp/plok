module Plok::Search
  class Term
    attr_reader :controller, :string

    def initialize(string, controller: nil)
      @string = string
      @controller = controller
    end

    def locale
      return controller.locale if controller.present?
      :nl
    end

    def valid?
      @string.present?
    end

    def value
      string
    end
  end
end
