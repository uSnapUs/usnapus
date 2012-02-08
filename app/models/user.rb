class User < ActiveRecord::Base
  
  devise :database_authenticatable, :registerable, :validatable, 
         :token_authenticatable, :recoverable, :trackable,
         :stretches => 10
         
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
end