class User < ActiveRecord::Base
  
  devise :database_authenticatable, :registerable, :validatable, 
         :token_authenticatable, :recoverable, :trackable,
         :stretches => 10
         
  has_many :attendees
  has_many :events, through: :attendees
  has_many :photos, as: :creator
  
  attr_accessible :email, :password, :remember_me
  
  def going_to? event
    attendees.where(:event_id => event.id).any?
  end
  
  def name
    email
  end
  
end