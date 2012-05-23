class HomeController < ApplicationController
  
  caches_page :terms_of_use, :privacy_policy
  before_filter :get_current_price
  
  def index
    @user = User.new
  end
  
  def terms_of_use
  end
  
  def privacy_policy
  end
  
  def geocode_search
    render json: Geocoder.search(params[:search]).to_json
  end
  
end
