require 'rails/generators/base'

class Plok::SidebarGenerator < Rails::Generators::Base
  source_root File.expand_path('templates', __dir__)
  class_option :css_framework, type: :string, default: 'bs5'

  def install
    copy_sidebar_files('wrapper', 'menu_items', 'menu_item', 'offcanvas_menu')
    add_scss_imports_to_application
    add_js_imports_to_application
    inject_wrapper_block_into_application_layout
    say("\nAll done! Remember to reboot your server so the new assets can load.\n\n")
  end

  private

  def add_js_imports_to_application
    if application_file(:js)
      unless file_contains?(application_file(:js), /\/\/= require plok\/sidebar/)
        append_to_file application_file(:js), "//= require plok/sidebar"
      end
    else
      say("\nWARNING: No suitable application.js file found.\n")
      say("Please add the following import to your backend application.js file:\n\n")
      say("//= require plok/sidebar\n\n")
    end
  end

  def add_scss_imports_to_application
    if application_file(:scss)
      unless file_contains?(application_file(:scss), /@import 'plok\/sidebar'/)
        append_to_file application_file(:scss), "@import 'plok/sidebar';\n"
      end

      unless file_contains?(application_file(:scss), /@import 'plok\/sidebar_compact'/)
        append_to_file application_file(:scss), "@import 'plok/sidebar_compact';\n"
      end
    else
      say("\nWARNING: No suitable application.scss file found.\n")
      say("Please add the following imports to your backend application.scss file:\n\n")
      say("@import 'plok/sidebar';\n")
      say("@import 'plok/sidebar_compact';\n")
    end
  end

  def inject_wrapper_block_into_application_layout
    # The sidebar wrapper already exists, so stop here.
    return if file_contains?(application_layout_file, /sidebar\/wrapper/)

    # The wrapper is missing, but we *need* a suitable spot for a closing tag.
    unless file_contains?(application_layout_file, /yield\(:javascripts_early\)/)
      say("\nWARNING: The generator could not inject the sidebar wrapper.\n")
      say("You will have to wrap your backend application markup in this block:\n\n")
      say("# #{application_layout_file}\n")
      say("<%= render 'backend/#{options.css_framework}/sidebar/wrapper', brand_name: '#{app_name}' do %>\n")
      say("  # ...your backend application markup here...\n")
      say("<% end %>\n")
      return
    end

    gsub_file(
      application_layout_file,
      /<body(.*)>\n/,
      "<body\\1>\n  <%= render 'backend/#{options.css_framework}/sidebar/wrapper', brand_name: '#{app_name}' do %>\n"
    )

    gsub_file(
      application_layout_file,
      /\n(.*)<%= yield\(:javascripts_early\) %>/,
      "  <% end %>\n\n\\1<%= yield(:javascripts_early) %>"
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
    "app/views/backend/#{options.css_framework}/sidebar/_#{partial_name}.html.erb"
  end

  def file_contains?(file, content)
    File.readlines(file).grep(content).any?
  end

  def application_layout_file
    if File.exist?("app/views/layouts/backend/#{options.css_framework}/application.html.erb")
      return "app/views/layouts/backend/#{options.css_framework}/application.html.erb"
    end

    if File.exist?('app/views/layouts/backend/application.html.erb')
      return 'app/views/layouts/backend/application.html.erb'
    end
  end

  def application_file(type)
    namespace = 'stylesheets'
    namespace = 'javascripts' if type.to_s == 'js'

    if File.exist?("app/assets/#{namespace}/backend/#{options.css_framework}/application.#{type}")
      return "app/assets/#{namespace}/backend/#{options.css_framework}/application.#{type}"
    end

    if File.exist?("app/assets/#{namespace}/backend/application.#{type}")
      return "app/assets/#{namespace}/backend/application.#{type}"
    end
  end
end
