require 'test_helper'

class PurchasesControllerTest < ActionController::TestCase
  
  setup do
    @user = Factory(:user)
    @pricing_tier = PricingTier::DEFAULT_PRICING_TIER
    @event = Factory(:current_event, pricing_tier: @pricing_tier, is_public: true)
    @attendee = Factory(:attendee, user: @user, event: @event, is_admin: true)
    
    @billing_attrs = {
      card_type: "Visa",
      number: "4987654321098769",
      card_name: "Testy McBob",
      month: (Date.today + 1.month).month,
      year: Date.today.year + 1,
      verification_value: "123"
    }
    
    sign_in @user
  end
  
  test "can see the billing form" do
    get :new, event_id: @event.to_param
    
    assert_select "form#new_billing_detail" do
      assert_select "select#billing_detail_card_type"
      assert_select "input#billing_detail_number"
      assert_select "input#billing_detail_card_name"
      assert_select "select#billing_detail_month"
      assert_select "select#billing_detail_year"
      assert_select "input#billing_detail_verification_value"
    end
    assert_select "span.price", "USD$99"
  end
  
  test "billing form currency can be changed by session" do
    session[:currency] = "NZD"
    get :new, event_id: @event.to_param
    assert_select "span.price", "NZD$129"
  end
  
  test "can purchase an event" do
    
    assert_difference "BillingDetail.count" do
      assert_difference "Purchase.count" do
        assert_difference "ChargeAttempt.count" do
          post :create, event_id: @event.to_param, billing_detail: @billing_attrs
        end
      end
    end
    assert_redirected_to event_photos_path(@event)
    
    ca = ChargeAttempt.last
    assert ca.success?
    
    pr = Purchase.last
    assert @event.reload.purchased?
    assert_equal @user, pr.user
    assert_equal @event, pr.event
    assert_equal ca, pr.charge_attempt
    assert_equal @pricing_tier.price_usd, pr.charge_attempt.amount
  end
  
  test "invalid billing details returns to new page" do
    assert_no_difference "BillingDetail.count" do
      assert_no_difference "Purchase.count" do
        assert_no_difference "ChargeAttempt.count" do
          post :create, event_id: @event.to_param, billing_detail: {
            number: "ABC123",
            card_name: "One_word",
            month: "",
            year: "",
            card_type: "",
            verification_value: ""
          }
        end
      end
    end
    assert_template :new
    assert_not_nil bd = assigns[:billing_detail]
    
    assert_equal [["is not a valid credit card number"]], bd.errors[:number]
    assert_equal [["is required"]], bd.errors[:month]
    assert_equal [["is required"]], bd.errors[:year]
    assert_equal [["cannot be empty"]], bd.errors[:last_name]
  end
  
  test "can purchase an event in NZD" do
    session[:currency] = "NZD"
    
    post :create, event_id: @event.to_param, billing_detail: @billing_attrs
    
    ca = ChargeAttempt.last
    assert_equal "NZD", @event.reload.currency, "Event's currency should be set to NZD"
    assert_equal "NZD", ca.currency
    assert_equal @pricing_tier.price_nzd, ca.amount
  end
  
  test "landing page price shows on new page" do
    #imitate landing on homepage with a different price
    # 51c causes insufficient funds in Rails.env.test. See purchase_test.rb
    pt = Factory(:pricing_tier, price_usd: 9951)
    @event.pricing_tier = pt
    @event.save
    
    get :new, event_id: @event.to_param
    assert_select ".price", "USD$99"
  end
  
  test "insufficient funds returns to new page" do
    pt = Factory(:pricing_tier, price_usd: 9951)
    @event.pricing_tier = pt
    @event.save
    
    assert_difference "BillingDetail.count" do
      assert_no_difference "Purchase.count" do
        assert_difference "ChargeAttempt.count" do
          post :create, event_id: @event.to_param, billing_detail: @billing_attrs
        end
      end
    end
    assert_response :success
    assert_template :new
    assert_equal "We couldn't charge your credit card: Insufficient funds. Need help? Email team@usnap.us", flash[:error]
  end
  
  test "wrong currency returns to new page" do
    pt = Factory(:pricing_tier, price_usd: 9912)
    @event.pricing_tier = pt
    @event.save
    
    post :create, event_id: @event.to_param, billing_detail: @billing_attrs
    assert_template :new
    assert_equal "We couldn't charge your credit card: Transaction type not supported. Need help? Email team@usnap.us", flash[:error]
  end
  
end
