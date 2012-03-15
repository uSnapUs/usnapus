class Notifier < Devise::Mailer
  default_url_options[:host] = "usnap.us"
  SUPPORT = "team@usnap.us"
  default :from => SUPPORT
  
  def bulk_download_request(user, event)
    @user = user
    @event = event
    @subject = "Bulk download request for #{@event.code}"
    mail :to => SUPPORT, :subject => @subject
  end
  
end