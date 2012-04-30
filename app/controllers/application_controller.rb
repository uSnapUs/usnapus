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
    if Rails.env.production? && !request.ssl?
      flash.keep
      redirect_to "https://usnap.us#{request.fullpath}"
    end
  end
  
end
