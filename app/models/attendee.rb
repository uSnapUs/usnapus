class Attendee < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  
  validates :event, presence: true
  validates :user, presence: true
  
  def self.between(user, event)
    Attendee.where(:user => user, :event => event)
  end
  
end
