class BillingDetail < ActiveRecord::Base

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
      month: month,
      year: year,
      first_name: first_name,
      last_name: last_name,
      verification_value: verification_value,
      type: card_type.downcase
    )
  end
  
  def charge(ip)
    Gateway.charge(self, ip) unless ip.blank?
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
