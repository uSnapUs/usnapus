class Event < ActiveRecord::Base
  
  has_many :photos
  
  
  validates :code, :format => {:with => /\A[A-HJKMNP-Z2-9]{7}\Z/, :on => :create}, :uniqueness => true
  
  before_validation :generate_code, :on => :create
  
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
  
  def self.deg2rad(degree)
    degree*Math::PI/180
  end
  
  private
    def generate_code
      #For usability, there are no I, 1, L, O, or 0
      base = Anybase.new("ABCDEFGHJKMNPQRSTUVWXYZ23456789")
      self.code = "#{base.random(7).upcase}"
      
      #Ensure uniqueness
      generate_code unless Event.find_by_code(self.code).nil?
    end
  
end
