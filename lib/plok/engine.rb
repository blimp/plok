# Can't use Plok::Engine.root yet at this point.
engine_root = File.expand_path('../..', __dir__)
Dir.glob("#{engine_root}/app/models/**/*.rb").each { |file| require file }

module Plok
  class Engine < ::Rails::Engine
    # https://hocnest.com/blog/testing-an-engine-with-rspec/
    # https://edgeguides.rubyonrails.org/engines.html#critical-files
    # This makes it so generators, helpers,... always reside in the engine's
    # namespace. So when a model gets generated, it gets put into
    # app/models/plok/log.rb.
    #
    # As you can see this is off for now, but if you do want it turned on
    # you can always do "Log = Plok::Log" in an initializer file to ease the
    # transition.
    #isolate_namespace Plok

    config.generators do |g|
      g.test_framework :rspec
    end

    # You can call this in your spec/rails_helper.rb file so you can make use
    # of the spec supports to test concerns.
    #
    # You cannot call it in the engine itself, because RSpec won't have the same
    # context available when tests are ran.
    def load_spec_supports
      Dir.glob("#{root}/spec/support/**/*.rb").each { |f| require f }
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
