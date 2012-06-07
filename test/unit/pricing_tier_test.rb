require 'test_helper'

class PricingTierTest < ActiveSupport::TestCase
  
  test "default price is USD99 NZD129" do
    assert_not_nil default = PricingTier::DEFAULT_PRICING_TIER
    assert_equal 12900, default.price_nzd
    assert_equal 9900, default.price_usd
  end
  
  test "factory is valid" do
    assert Factory.build(:pricing_tier).valid?
  end
  
  test "requires usd and nzd value" do
    assert Factory.build(:pricing_tier, :price_usd => nil).invalid?
    assert Factory.build(:pricing_tier, :price_nzd => nil).invalid?
  end
  
  test "price cant be < 0" do
    assert Factory.build(:pricing_tier, :price_usd => -1).invalid?
    assert Factory.build(:pricing_tier, :price_nzd => -1).invalid?
  end
  
end
