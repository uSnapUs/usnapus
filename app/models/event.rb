class Event < ActiveRecord::Base
  
  geocoded_by :location
  after_validation :geocode
  reverse_geocoded_by :latitude, :longitude
  after_validation :reverse_geocode
  
  has_many :photos
  
  validates :code, :format => {:with => /\A[A-HJKMNP-Z2-9]{7}\Z/, :on => :create}, :uniqueness => true
  
  before_validation :generate_codes, :on => :create
  
  validates :code, presence: {allow_blank: false}
  validates :code, uniqueness: true
  validates :s3_token, presence: {allow_blank: false}, uniqueness: true
  
  
  attr_accessible :latitude, :longitude, :starts, :ends
  
  scope :near, lambda{ |*args|
    origin = *args.first[:origin]
    if (origin).is_a?(Array)
      origin_latitude, origin_longitude = origin
    else
      origin_latitude, origin_longitude = origin.latitude, origin.longitude
    end
    origin_latitude, origin_longitude = self.deg2rad(origin_latitude), self.deg2rad(origin_longitude)
    within = *args.first[:within]
    {
      :conditions => %(
        (ACOS(COS(#{origin_latitude})*COS(#{origin_longitude})*COS(RADIANS(events.latitude))*COS(RADIANS(events.longitude))+
        COS(#{origin_latitude})*SIN(#{origin_longitude})*COS(RADIANS(events.latitude))*SIN(RADIANS(events.longitude))+
        SIN(#{origin_latitude})*SIN(RADIANS(events.latitude)))*3963) <= #{within[0]}),
      :select => %(events.*,
        (ACOS(COS(#{origin_latitude})*COS(#{origin_longitude})*COS(RADIANS(events.latitude))*COS(RADIANS(events.longitude))+
        COS(#{origin_latitude})*SIN(#{origin_longitude})*COS(RADIANS(events.latitude))*SIN(RADIANS(events.longitude))+
        SIN(#{origin_latitude})*SIN(RADIANS(events.latitude)))*3963) AS distance
      )
    }
  }
  
  scope :current, where(" :now > starts AND :now < ends ", {now: Time.zone.now})
  scope :visible, where(:is_public => true)
  
  def self.deg2rad(degree)
    degree*Math::PI/180
  end
  
  private
    def generate_codes
      generate_s3_token
      generate_event_code
    end
    
    def generate_s3_token
      self.s3_token = SecureRandom.hex(16)
      generate_s3_token unless Event.find_by_s3_token(self.s3_token).nil?
    end
      
    def generate_event_code
      #For usability, there are no I, 1, L, O, or 0
      base = Anybase.new("ABCDEFGHJKMNPQRSTUVWXYZ23456789")
      self.code = "#{base.random(7).upcase}"
      
      #Ensure uniqueness
      generate_event_code unless Event.find_by_code(self.code).nil?
    end
  
end
