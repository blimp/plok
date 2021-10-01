module Plok
  class Engine < ::Rails::Engine
    # Read more about isolate_namespace here:
    # https://hocnest.com/blog/testing-an-engine-with-rspec/
    isolate_namespace Plok

    config.generators do |g|
      g.test_framework :rspec
    end

    def class_exists?(class_name)
      klass = Module.const_get(class_name.to_s)
      return klass.is_a?(Class)
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
