require 'rails/generators/base'

class Plok::SidebarGenerator < Rails::Generators::Base
  source_root File.expand_path('templates', __dir__)

  def install
    copy_sidebar_files('wrapper', 'menu_item', 'offcanvas_menu')
    gsub_file sidebar_partial_path('wrapper'), '[brand_name]', app_name
    gsub_file sidebar_partial_path('offcanvas_menu'), '[brand_name]', app_name

    if application_scss_file
      append_to_file application_scss_file, "@import 'plok/sidebar';\n"
      append_to_file application_scss_file, "@import 'plok/sidebar_compact';\n"
    else
      say("WARNING: No suitable application.scss file found.\n")
      say("Please add the following imports to your backend application.scss file:\n\n")
      say("@import 'plok/sidebar';\n")
      say("@import 'plok/sidebar_compact';\n")
    end
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

  def application_scss_file
    if File.exists?('app/assets/stylesheets/backend/bs5/application.scss')
      return 'app/assets/stylesheets/backend/bs5/application.scss'
    end

    if File.exists?('app/assets/stylesheets/backend/application.scss')
      return 'app/assets/stylesheets/backend/application.scss'
    end
  end
end
