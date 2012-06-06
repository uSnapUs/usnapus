require 'test_helper'

class LandingPagesControllerTest < ActionController::TestCase
  setup do
    @path = "test"
    @landing_page = LandingPage.create do |l|
      l.path = @path
      l.pricing_tier = PricingTier::DEFAULT_PRICING_TIER
      l.body_html = "<h1 class=\"test_header\">Test</h1>"
    end
  end

  test "should show landing_page" do
    get :show, path: @path
    assert_response :success
    assert_equal PricingTier::DEFAULT_PRICING_TIER.id, session[:pricing_tier_id]
    assert_select "span.price", "USD$99"
  end
  
end
