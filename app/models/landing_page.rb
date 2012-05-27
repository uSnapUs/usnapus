class LandingPage < ActiveRecord::Base
  
  belongs_to :pricing_tier
  
  validates :pricing_tier, presence: true
  validates :path, presence: {allow_blank: false}
  
end
