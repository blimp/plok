require 'rails/generators/base'

class Plok::SidebarGenerator < Rails::Generators::Base
  source_root File.expand_path('templates', __dir__)

  def install
    copy_sidebar_files('wrapper', 'menu_items', 'menu_item', 'offcanvas_menu')
    add_imports_to_application_scss
    inject_wrapper_block_into_application_layout
  end

  private

  def add_imports_to_application_scss
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

  def inject_wrapper_block_into_application_layout
    gsub_file(
      application_layout_file,
      /<body(.*)>\n/,
      "<body\\1>\n    <%= render 'backend/bs5/sidebar/wrapper', brand_name: '#{app_name}' do %>\n"
    )

    gsub_file(
      application_layout_file,
      %Q(\n    <%= yield(:javascripts_early) %>),
      "    <% end %>\n\n    <%= yield(:javascripts_early) %>"
    )
  end

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

  def application_layout_file
    if File.exists?('app/views/layouts/backend/bs5/application.html.erb')
      return 'app/views/layouts/backend/bs5/application.html.erb'
    end

    if File.exists?('app/views/layouts/backend/application.html.erb')
      return 'app/views/layouts/backend/application.html.erb'
    end
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
