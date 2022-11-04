require 'rails/generators/base'

class Plok::Search::ClassGenerator < Rails::Generators::Base
  source_root File.expand_path('templates', __dir__)
  class_option :namespace, type: :string

  def create
    copy_file "namespace_class.rb", namespace_class_path
    copy_file "namespace_class_spec.rb", namespace_class_spec_path
    gsub_file(namespace_class_path, '[namespace]', namespace_class)
    gsub_file(namespace_class_spec_path, '[namespace]', namespace_class)
    gsub_file(namespace_class_spec_path, '[snakecased_namespace]', options.namespace)
  end

  private

  def app_name
    Rails.application.class.name.split('::').first
  end

  def namespace_class_path
    "lib/plok/search/#{options.namespace}.rb"
  end

  def namespace_class_spec_path
    "spec/lib/plok/search/#{options.namespace}_spec.rb"
  end

  def file_contains?(file, content)
    File.readlines(file).grep(content).any?
  end

  def namespace_class
    options.namespace.to_s.camelcase
  end
end
