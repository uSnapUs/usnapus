class Photo < ActiveRecord::Base

  mount_uploader :photo, PhotoUploader
  process_in_background :photo unless Rails.env.test?
  
  belongs_to :event
  belongs_to :creator, polymorphic: true
  
  validates :event_id, presence: true
  validates :creator_type, presence: true
  validates :creator_id, presence: true
  validate :event_exists
  validate :creator_must_exist
  
  attr_accessible :photo
  
  scope :processed, where(:photo_processing => nil)
  
  def as_json(options = {})
    timestamp = "?#{updated_at.to_i}"
    super(options.merge({except: [:photo]})).merge(
      creator_name: "#{creator.name if creator}", 
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
    def event_exists
      errors.add(:event_id, "must point to an existing event") if event.nil?
    end
    
    def creator_must_exist
      errors.add(:creator, "must point to an existing device or user") if creator.nil?
    end
  
end
