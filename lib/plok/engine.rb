module Plok
  class Engine < ::Rails::Engine
    # https://hocnest.com/blog/testing-an-engine-with-rspec/
    # https://edgeguides.rubyonrails.org/engines.html#critical-files
    # I don't think we want this, but I'm keeping it here as a reference
    # for when shit is leaking where it shouldn't go.
    #isolate_namespace Plok

    config.generators do |g|
      g.test_framework :rspec
    end

    def class_exists?(class_name)
      klass = Module.const_get(class_name.to_s)
      klass.is_a?(Class)
    rescue NameError
      return false
    end

    def module_exists?(module_name)
      # By casting to a string and making a constant, we can assume module_name
      # can be either one without it being a problem.
      module_name.to_s.constantize.is_a?(Module)
    rescue NameError
      return false
    end
  end
end
