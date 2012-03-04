class Photo < ActiveRecord::Base

  mount_uploader :photo, PhotoUploader
  process_in_background :photo
  
  belongs_to :event
  belongs_to :device
  
  validates :event_id, presence: true
  validate :event_and_device_must_exist
  
  attr_accessible :photo
  
  scope :processed, where(:photo_processing => nil)
  
  def as_json(options = {})
    timestamp = "?#{updated_at.to_i}"
    super(options.merge({except: [:photo]})).merge(
      device_name: "#{device.name if device}", 
      photo: {
        url: "#{photo.url}#{timestamp}",
        thumbnail: {
          url: "#{photo.url(:thumbnail)}#{timestamp}"
        },  
        xga: {
          url: "#{photo.url(:xga)}#{timestamp}"
        }
      })
  end
  
  def after_processing
    Pusher["#{Rails.env}-event-#{event.id}-photocast"].trigger!('new_photo', self)
  end
  
  #Eggregious hax to get the browser to reload a photo
  def reload_image
    touch
    Pusher["#{Rails.env}-event-#{event.id}-photocast"].trigger!('update_photo', self)
  end
  
  private
  
    def event_and_device_must_exist
      errors.add(:event_id, "must point to an existing event") if event_id && event.nil?
      errors.add(:device_id, "must point to an existing device") if device_id && device.nil?
    end
  
end
