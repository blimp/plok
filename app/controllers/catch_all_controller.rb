class CatchAllController < ApplicationController
  def resolve
    format.all { render plain: 'Page not found', status: :not_found }
  end
end
