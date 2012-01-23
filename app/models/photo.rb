class Photo < ActiveRecord::Base

  mount_uploader :photo, PhotoUploader
  
  belongs_to :event
  belongs_to :device
  
  validates :event_id, presence: true
  validates :device_id, presence: true
  
end
