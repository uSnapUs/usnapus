require 'active_merchant'

class Gateway

  @gateway = if Rails.env.production?
              ActiveMerchant::Billing::PaypalExpressGateway.new(
                login: "",
                password: "",
                signature: ""
              )
            else
              #Use PayPal's Sandbox Gateway
              ActiveMerchant::Billing::Base.mode=:test

              ActiveMerchant::Billing::PaypalExpressGateway.new(
                login: "usnap_1331415667_biz@gmail.com",
                password: "1331415688",
                signature: "AmU.GqEl-6sug4FmTn1FYVx-a3K9Am10IpED7XxLzRgHR3iikWYpIJwV"
              )
            end
  
  def self.charge(billing_detail, ip)
    amount = 99*100 # USD$99 in cents
    charge_attempt = ChargeAttempt.new do |ca|
      ca.billing_detail = billing_detail
      ca.amount = amount
    end
    
    credit_card = billing_detail.to_credit_card
    
    if credit_card.valid?
      response = @gateway.purchase(amount, credit_card, ip:  ip)
      y response
      charge_attempt.authorization = response.authorization
      
      if response.success?
        charge_attempt.success = true
      else
        charge_attempt.success = false
        charge_attempt.message = response.message
      end
    else
      charge_attempt.success = false
      charge_attempt.message = "Credit card is not valid: #{credit_card.errors.full_messages.join('. ')}"
    end
    
    charge_attempt.save!
    charge_attempt
  end
  
end