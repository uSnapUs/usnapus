class BillingDetail < ActiveRecord::Base
  
  cattr_accessor :gateway
  self.gateway = Gateway::TestImplementation.new

  belongs_to :user
  has_many :charge_attempts
  
  attr_accessor :number, :verification_value, :month, :year
  
  validate :validate_using_active_merchant, on: :create
  before_create :remember_last_four_digits
  
  def description
    "#{card_type} ending in #{last_four_digits}"
  end
  
  def to_credit_card
    first_name, last_name = card_name.try(:split, "\s")
    
    ActiveMerchant::Billing::CreditCard.new(
      number: number.try { |n| n.gsub(/\D/, '') },
      month: month.to_i,
      year: year,
      first_name: first_name,
      last_name: last_name,
      verification_value: verification_value,
      type: card_type.try(:downcase)
    )
  end
  
  def charge(amount, currency)
    response = self.gateway.charge(self, amount, currency)
    self.charge_attempts.create do |ca|
      ca.success = response.success
      ca.message = response.message
      ca.error_code = response.error_code
      ca.transaction_identifier = response.transaction_identifier
      ca.declined = response.declined?
      ca.merchant_session = response.merchant_session
      ca.amount = amount
      ca.currency = currency
    end
  end
  
  private
  
    def validate_using_active_merchant
      cc = to_credit_card
      cc.validate
      cc.errors.each do |attribute, message|
        self.errors.add(attribute, message)
      end
    end  
      
    def remember_last_four_digits
      self.last_four_digits = number.last(4)
    end
  
end
