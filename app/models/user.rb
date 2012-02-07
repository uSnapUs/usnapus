class User < ActiveRecord::Base
  
  devise :database_authenticatable, :token_authenticatable, :validatable,
         :confirmable, :recoverable, :trackable, :registerable, 
         :stretches => 20, :confirm_within => 2.days
  

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
end
