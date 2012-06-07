require 'test_helper'

class LandingPageTest < ActiveSupport::TestCase
  
  test "factory is valid" do
    assert Factory.build(:landing_page).valid?
  end
  
  test "requires pricing tier" do
    assert Factory.build(:landing_page, pricing_tier: nil).invalid?
  end
  
  test "requires non-blank path" do
    assert Factory.build(:landing_page, path: nil).invalid?
    assert Factory.build(:landing_page, path: "").invalid?
  end
  
end
