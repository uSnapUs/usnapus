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
    
    if inbound_email.try(:has_event?)
      email.attachments.each do |attachment|
        if %w(image/jpeg image/png).include? attachment.content_type
          
          ext = ""
          case attachment.content_type
          when "image/jpeg"
            ext = "jpg"
          when "image/png"
            ext = "png"
          end
          
          raw = attachment.source["Content"]
          content = if raw.respond_to?(:force_encoding)
                      raw.force_encoding("UTF-8")
                    else
                      raw
                    end
          
          dir = "#{Rails.root.join("tmp")}/ie/#{inbound_email.message_id.parameterize}"
          FileUtils.mkdir_p(dir)
          File.open("#{dir}/test.jpg", 'wb') do |f|
            f.write(Base64.decode64(content))
          end
          
          Photo.create! do |photo|
            photo.event   = inbound_email.event
            photo.creator = inbound_email
            photo.photo = File.open("#{dir}/test.jpg")
          end
        end
      end
    end
    
    head :ok
  end
  
  private
    def verify_postmark
      unless params.has_key?(:token) and params[:token].eql?("8eec23eae3465a1078ba541367f4dadd")
        head :not_found
      end
    end
  
end