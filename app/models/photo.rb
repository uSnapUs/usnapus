class Photo < ActiveRecord::Base

  mount_uploader :photo, PhotoUploader
  
  belongs_to :event
  validates :event, presence: true
  
end
