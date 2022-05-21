require 'rails/generators/base'

class Plok::SidebarGenerator < Rails::Generators::Base
  source_root File.expand_path('templates', __dir__)

  def copy_initializer_file
    copy_sidebar_files('wrapper', 'menu_item', 'offcanvas_menu')
    gsub_file sidebar_partial_path('wrapper'), '[brand_name]', app_name
    gsub_file sidebar_partial_path('offcanvas_menu'), '[brand_name]', app_name
  end

  private

  def app_name
    Rails.application.class.name.split('::').first
  end

  def copy_sidebar_files(*partials)
    partials.each do |partial_name|
      copy_file "_#{partial_name}.html.erb", sidebar_partial_path(partial_name)
    end
  end

  def sidebar_partial_path(partial_name)
    "app/views/backend/bs5/sidebar/_#{partial_name}.html.erb"
  end
end
