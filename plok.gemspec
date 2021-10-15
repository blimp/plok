$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require 'plok/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "plok"
  spec.version     = Plok::VERSION
  spec.authors     = ['Davy Hellemans', 'Dave Lens']
  spec.email       = %w(davy@blimp.be dave@blimp.be)
  spec.homepage    = 'https://plok.blimp.be'
  spec.summary     = 'CMS basics'
  spec.description = 'Some basics used for setting up rails projects'
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = 'https://rubygems.org'
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = Dir[
    "{app,config,db,lib}/**/*",
    "spec/{factories,support}/**/*",
    "MIT-LICENSE",
    "Rakefile"
  ]

  spec.add_dependency 'rails', '~> 6.0'
  spec.add_development_dependency 'mysql2'
  spec.add_development_dependency 'rspec-rails', '~> 5.0'
  spec.add_development_dependency 'factory_bot_rails', '~> 6.0'
end
