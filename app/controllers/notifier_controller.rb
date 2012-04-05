class NotifierController < ApplicationController
  
  layout 'notifier'
  before_filter :dev_only
  
  def welcome
    @user = User.first
    @event = Event.last
    @event.is_public = false
    @event.free = false
    @event.save!
  end
  
  def bulk_download_request
    @user = User.first
    @event = Event.first
  end
  
  
  private
    def dev_only
      unless Rails.env.development?
        head :not_found
      end
    end
end