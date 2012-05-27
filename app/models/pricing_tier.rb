class PricingTier < ActiveRecord::Base
  
  DEFAULT_PRICING_TIER = PricingTier.find_or_create_by_price_nzd_and_price_usd(12900, 9900)
  
  validates :price_nzd, numericality: {greater_than_or_equal_to: 0}
  validates :price_usd, numericality: {greater_than_or_equal_to: 0}
  
  
  
end
