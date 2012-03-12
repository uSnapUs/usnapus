class User < ActiveRecord::Base
  
  has_many :billing_details
  
  devise :database_authenticatable, :registerable, :validatable, 
         :token_authenticatable, :recoverable, :trackable
         
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
end