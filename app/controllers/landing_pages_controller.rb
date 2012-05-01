class LandingPagesController < ApplicationController

  def show
    @user = User.new
    @landing_page = LandingPage.find_by_path(params[:path])
    if @landing_page
      session["landing_page"] = @landing_page.path
    else
      redirect_to root_path
    end
  end
  
end
