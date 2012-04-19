class User < ActiveRecord::Base
  
  has_many :billing_details
  
  devise :database_authenticatable, :registerable, :validatable, 
         :token_authenticatable, :recoverable, :trackable
         
  has_many :attendees
  has_many :events, through: :attendees
  has_many :photos, as: :creator
  
  attr_accessible :email, :password, :remember_me, :name
  
  def going_to? event
    attendees.where(:event_id => event.id).any?
  end
  
end