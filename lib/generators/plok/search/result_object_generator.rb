require 'rails/generators/base'

class Plok::Search::ResultObjectGenerator < Rails::Generators::Base
  source_root File.expand_path('templates', __dir__)
  class_option :name, type: :string
  class_option :namespace, type: :string

  def create
    # TODO: Check for missing params
    copy_file 'result_object.rb', class_path
    gsub_file(class_path, '[name]', options.name)
    gsub_file(class_path, '[namespace]', options.namespace)
    gsub_file(class_path, '[class_name]', to_snakecase(options.name))
    gsub_file(class_path, '[namespace_module_name]', to_snakecase(options.namespace))

    copy_file 'result_object.html.erb', markup_path
    gsub_file(markup_path, '[name]', options.name)
  end

  private

  def app_name
    Rails.application.class.name.split('::').first
  end

  def class_path
    "lib/plok/search/result_objects/#{options.namespace}/#{options.name}.rb"
  end

  def markup_path
    "app/views/plok/search/result_objects/#{options.namespace}/_#{options.name}.html.erb"
  end

  def namespace_class_spec_path
    "spec/lib/plok/search/#{options.namespace}_spec.rb"
  end

  def to_snakecase(name)
    name.to_s.camelcase
  end
end
