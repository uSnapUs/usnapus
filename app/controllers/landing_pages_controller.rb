class LandingPagesController < ApplicationController

  before_filter :redirect_to_blog

  def show
    @user = User.new
    @landing_page = LandingPage.find_by_path(params[:path])
    if @landing_page
      session[:pricing_tier_id] = @landing_page.pricing_tier_id
    else
      redirect_to root_path
    end
  end
  
end
