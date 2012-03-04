class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def not_found
    raise ActiveRecord::RecordNotFound.new("")
  end
  
  def current_device
    auth_header = request.headers["Authorization"]
    if auth_header =~ /Device token="(.*)"/ 
      Device.find_by_guid($1)
    end
  end
  
end
