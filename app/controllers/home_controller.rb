class HomeController < ApplicationController
  
  caches_page :index
  
  def index
  	render :layout=>'front_page'
  end
  
  def terms_of_use
  end
  
  def privacy_policy
  end
  
  def geocode_search
    render json: Geocoder.search(params[:search]).to_json
  end
  
end
