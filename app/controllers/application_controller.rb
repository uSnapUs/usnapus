require 'bootstrap_errors'

class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def not_found
    raise ActiveRecord::RecordNotFound.new("")
  end
  
  def current_device
    auth_header = request.headers["Authorization"]
    if auth_header =~ /Device token=(.*)/ 
      Device.find_by_guid($1)
    end
  end
  
  def current_attendee
    if current_user && @event
      Attendee.find_by_user_id_and_event_id(current_user.id, @event.id)
    end
  end
  
  def current_thing
    current_user || current_device
  end
  
  def ssl_required
    if !request.ssl? && Rails.env.production?
      flash.keep
      redirect_to "https://#{request.host}#{request.fullpath}"
    end
  end
  
  def current_pricing_tier
    @_current_pricing_tier = (PricingTier.find_by_id(session[:pricing_tier_id]) || PricingTier::DEFAULT_PRICING_TIER)
  end  
  helper_method :current_pricing_tier
  
  def current_price
    @_current_price = current_pricing_tier.price_in_currency(current_currency)
  end
  helper_method :current_price
  
  def current_currency
    session[:currency] ||= request.location.country.eql?("New Zealand") ? "NZD" : "USD"
    @_current_currency = session[:currency]
  end
  helper_method :current_currency
  
end
