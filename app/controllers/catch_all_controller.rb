class CatchAllController < ApplicationController
  def resolve
    respond_to do |format|
      format.all { render plain: 'Page not found', status: :not_found }
    end
  end
end
