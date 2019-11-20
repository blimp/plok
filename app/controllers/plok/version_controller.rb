class Plok::VersionController < ActionController::Base
  def show
    respond_to do |format|
      format.all { render plain: Plok::VERSION }
    end
  end
end
