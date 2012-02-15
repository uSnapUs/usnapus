class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def not_found
    raise ActiveRecord::RecordNotFound.new("")
  end
end
