class Notifier < Devise::Mailer
  default_url_options[:host] = "usnap.us"
  
  SUPPORT = if Rails.env.production?
              "team@usnap.us"
            else
              "nick@usnap.us"
            end
            
  default :from => SUPPORT
  
  def welcome(user, event)
    @user = user
    @event = event
    @subject = "Yay! Thanks for joining uSnap.us"
    mail to: "#{user.name} <#{user.email}>", bcc: SUPPORT, subject: @subject
  end
  
  def bulk_download_request(user, event)
    @user = user
    @event = event
    @subject = "Bulk download request for #{@event.code}"
    mail to: SUPPORT, subject: @subject
  end
  
  def upgrade(user, event)
    @user = user
    @event = event
    @subject = "#{@event.name} upgraded!"
    mail to: SUPPORT, subject: @subject
  end
  
  private
    def named_email(user)
      "#{user.name} <#{user.email}>"
    end
  
end