require 'active_merchant'
require 'simple_uuid'
class Gateway
  class Response < Struct.new(:success, :message, :error_code, :transaction_identifier, :merchant_session)
    def declined? #Was the error with their account. i.e. not the transaction/network
      error_code.to_i < 10 && error_code.to_i > 0
    end
  end

  def initialize(paystation_id, gateway_id)
    @gateway = ActiveMerchant::Billing::PaystationGateway.new(:paystation_id=>paystation_id, :gateway_id=>gateway_id)
  end
  
  # ActiveMerchant accepts all amounts as Integer values in cents
  def charge(billing_detail, amount, currency)
    response = @gateway.purchase(
        amount.to_i, 
        billing_detail.to_credit_card, 
        :currency=>currency, 
        :order_id=>unique_request_id, 
        :description=>"..."
      )
    
    Rails.logger.info(response.inspect)
    
    Response.new(
        response.success?, 
        response.message, 
        response.params["ec"], 
        response.params["ti"], 
        response.params["merchant_session"]
      )
  end
  
  
  def unique_request_id
    SimpleUUID::UUID.new.to_guid
  end
  
  class TestImplementation
    
    #
    # The test implementation mimics the responses based on the cents part of the amount, 
    # just as a PayStation account in test mode does, but skips actually talking to PayStation
    #
    def charge(billing_details, amount, currency)
      transaction_id = "000939494-01"
      merchant_session = SimpleUUID::UUID.new.to_guid
      
      cents = amount%100
      case cents
      when 00
        return Response.new(true, nil, "0", transaction_id, merchant_session)
      when 51
        return Response.new(false, "Insufficient funds", "5", transaction_id, merchant_session)
      when 12  
        return Response.new(false, "Transaction type not supported", "8", transaction_id, merchant_session)
      when 54
        return Response.new(false, "Expired card", "4", transaction_id, merchant_session)
      when 91
        return Response.new(false, "Error communicating with bank", "6", transaction_id, merchant_session)
      end
    end
  end
  
end