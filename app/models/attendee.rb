class Attendee < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  
  validates :event, presence: true
  validates :user, presence: true
  
end
