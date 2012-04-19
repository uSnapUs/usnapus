class Attendee < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  
  validates :event, presence: true
  validates_uniqueness_of :event_id, scope: :user_id
  validates :user, presence: true
  
  def self.between(user, event)
    Attendee.find_by_user_id_and_event_id(user.id, event.id)
  end
  
end
