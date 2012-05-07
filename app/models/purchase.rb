class Purchase < ActiveRecord::Base
  
  CURRENCIES = %w(USD NZD)
  
  belongs_to :user
  belongs_to :event
  belongs_to :charge_attempt
  validates_inclusion_of :currency, in: CURRENCIES
  validates_uniqueness_of :event_id, message: "has already been purchased"
  
  def gst_applies?
    self.currency.eql?("NZD")
  end
  
  def capture(billing_detail)
    billing_detail.charge(self.amount, self.currency)
  end
  
  def success?
    charge_attempt.try(:success)
  end
  
  def description
    "#{event.title} for #{currency}$#{amount/100}.#{amount%100}"
  end
  
end
