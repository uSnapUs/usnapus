class User < ActiveRecord::Base
  
  has_many :billing_details
  has_many :purchases
  
  devise :database_authenticatable, :registerable, :validatable, 
         :token_authenticatable, :recoverable, :trackable
         
  has_many :attendees
  has_many :events, through: :attendees
  has_many :photos, as: :creator
  
  attr_accessible :email, :password, :remember_me, :name
  
  def going_to? event
    attendees.where(:event_id => event.id).any?
  end
  
  def purchase(event, billing_detail, amount, currency)
    
    purchase = self.purchases.new do |p|
      p.event = event
      p.amount = amount
      p.currency = currency
    end
    
    if purchase.valid?
      charge_attempt = purchase.capture(billing_detail)
      if charge_attempt.success?
        #Successful payment
        purchase.charge_attempt = charge_attempt
        purchase.save!
      else
        #Unsuccessful payment
        purchase.errors.add(:credit_card, charge_attempt.message)
      end
    end
    purchase
  end
  
end