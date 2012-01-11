require 'createsend'
class CampaignMonitor
  
  API_KEY = 'c4bc9b0adfe1a765e9553223253cb3f7'
  LIST_ID = 'bf139b0f043b0a2cdf003c2cd5e00af2'
  def self.sync(email_object)
    CreateSend.api_key API_KEY
    
    CreateSend::Subscriber.add LIST_ID, email_object.email, 'Subscriber', false
  rescue CreateSend::BadRequest => br
    Rails.logger.error "Bad request error: #{br}"
    Rails.logger.error "Error Code:    #{br.data.Code}"
    Rails.logger.error "Error Message: #{br.data.Message}"
  rescue Exception => e
    Rails.logger.error "Error: #{e}"
  end
  
end