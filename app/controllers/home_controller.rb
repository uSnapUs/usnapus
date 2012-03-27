class HomeController < ApplicationController
  
  caches_page :index
  
  def index
  	render :layout=>'front_page'
  end
  
  def geocode_search
    render json: Geocoder.search(params[:search]).to_json
  end
  
end
