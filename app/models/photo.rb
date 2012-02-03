class Photo < ActiveRecord::Base

  mount_uploader :photo, PhotoUploader
  
  belongs_to :event
  belongs_to :device
  
  validates :event_id, presence: true
  validates :device_id, presence: true
  validate :event_and_device_must_exist
  
  def as_json(options = {})
    super(options).merge(:device_name => "#{device.name} (#{device.email})")
  end
  
  private
  
    def event_and_device_must_exist
      errors.add(:event_id, "must point to an existing event") if event_id && event.nil?
      errors.add(:device_id, "must point to an existing device") if device_id && device.nil?
    end
  
end
