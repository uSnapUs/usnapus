class Event < ActiveRecord::Base
  
  CODE_BLACKLIST = %w(NICK OWEN BROCK LUKE TEAM HELP SUPPORT RESQUE PRIVACY WEBMASTER TERMS BLOG PRESS ABOUT USERS EVENTS ADMIN DEVICES)
  
  geocoded_by :location
  after_validation :geocode_if_lat_lng_missing
  reverse_geocoded_by :latitude, :longitude, address: :location
  after_validation :reverse_geocode
  
  has_many :photos
  has_many :attendees
  has_many :users, through: :attendees
  has_one :purchase
  belongs_to :landing_page
  
  before_validation :generate_codes, on: :create
  before_validation :assign_event_code
  
  validates :s3_token, presence: {allow_blank: false}, uniqueness: true
  validates :code, format: { with: /\A[A-Z0-9\-]+\Z/}, uniqueness: true
  validates_exclusion_of :code, in: CODE_BLACKLIST, message: "%{value} is already taken"
  
  attr_accessible :location, :name, :latitude, :longitude, :starts, :ends, :code, :is_public
  
  scope :current, where(" :now > starts AND :now < ends ", {now: Time.zone.now})
  scope :visible, where(:is_public => true)
  
  def as_json(options={})
    #Don't include the password, ever.
    if options[:except].nil?
      options[:except] = [:s3_token]
    else
      options[:except] << :s3_token
    end
    super(options)
  end
  
  def self.deg2rad(degree)
    degree*Math::PI/180
  end
  
  def self.generate_unique_code
    #For usability, there are no I, 1, L, O, or 0
    base = Anybase.new("ABCDEFGHJKMNPQRSTUVWXYZ23456789")
    code = "#{base.random(7).upcase}"
  
    #Ensure uniqueness
    if Event.find_by_code(code).nil?
      code
    else
      Event.generate_unique_code 
    end
  end
  
  def purchased?
    self.purchase.present? || !self.free
  end
  
  private
    def generate_codes
      generate_s3_token
      assign_event_code
    end
    
    def generate_s3_token
      self.s3_token = SecureRandom.hex(16)
      generate_s3_token unless Event.find_by_s3_token(self.s3_token).nil?
    end
      
    def assign_event_code
      if self.code.blank?
        self.code = Event.generate_unique_code
      else
        self.code = self.code.parameterize.upcase
      end
    end
    
    def geocode_if_lat_lng_missing
      #We prioritize a given lat and long, so people can customize
      # the actual event location.
      #However if only a address is provided, we need
      # to figure out the lat and long ourselves.
      if latitude.nil? && longitude.nil?
        self.geocode
      end
    end
  
end
