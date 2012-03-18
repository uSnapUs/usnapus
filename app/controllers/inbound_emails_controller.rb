class InboundEmailsController < ApplicationController
  
  before_filter :verify_postmark
  
  def create
    email = Postmark::Mitt.new(request.body.read)
    
    inbound_email = InboundEmail.create do |ie|
      ie.from = email.from
      ie.name = email.from_name
      ie.to = email.to
      ie.message_id = email.message_id
    end
    
    if inbound_email
      
      email.attachments.each do |attachment|
        if %w(image/jpeg image/png).include? attachment.content_type
          Photo.create do |photo|
            photo.event   = inbound_email.event
            photo.creator = inbound_email
            photo.photo   = Base64Photo.new(attachment.read, attachment.file_name, attachment.content_type)
          end
        end
      end
      
    end
  end
  
  private
    def verify_postmark
      unless params.has_key?(:token) and params[:token].eql?("8eec23eae3465a1078ba541367f4dadd")
        head :not_found
      end
    end
  
end