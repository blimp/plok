require 'rails_helper'
require 'rails/generators'
require 'rails/generators/actions'
require 'rails/generators/base'
require Rails.root.join('../../lib/generators/plok/sidebar/sidebar_generator.rb').to_s

describe Plok::SidebarGenerator, type: :generator do
  # TODO: Find out how to init a generator subject properly.
  #it 'copies files' do
    #expect { subject.install }.to change {
      #File.exist?('app/views/plok/sidebar.html.erb')
    #}.from(false).to(true)
  #end
end
