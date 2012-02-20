class HomeController < ApplicationController
  
  caches_page :index
  
  def index
  end
  
  def geocode_search
    render json: Geocoder.search(params[:search]).try(:first).to_json
  end
  
end
