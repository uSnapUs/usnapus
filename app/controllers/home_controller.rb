class HomeController < ApplicationController
  
  caches_page :terms_of_use, :privacy_policy
  
  before_filter :redirect_to_blog, only: [:index]

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
  
  def change_currency
    if params[:currency].in? PricingTier::CURRENCIES
      session[:currency] = params[:currency]
    end
    render json: current_pricing_tier.price_in_currency(current_currency)
  end
  
end
