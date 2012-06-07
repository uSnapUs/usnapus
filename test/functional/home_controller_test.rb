require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  
  test "going to index sets currency" do
    get :index
    assert_equal "USD", session[:currency]
  end
  
  test "can change currency" do
    session[:currency] = "USD"
    put :change_currency, currency: "NZD"
    assert_equal PricingTier::DEFAULT_PRICING_TIER.price_nzd, response.body.to_i
    assert_equal "NZD", session[:currency]
  end
  
  test "fudging currency sets to USD" do
    session[:currency] = "USD"
    put :change_currency, currency: "AUD"
    assert_equal PricingTier::DEFAULT_PRICING_TIER.price_usd, response.body.to_i
    assert_equal "USD", session[:currency]
  end
  
end
