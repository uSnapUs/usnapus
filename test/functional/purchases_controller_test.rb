require 'test_helper'

class PurchasesControllerTest < ActionController::TestCase
  
  setup do
    @user = Factory(:user)
    @event = Factory(:current_event, is_public: true)
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
    assert_select "#price", "USD$199"
  end
  
  test "can purchase an event" do
    
    assert_difference "BillingDetail.count" do
      assert_difference "Purchase.count" do
        assert_difference "ChargeAttempt.count" do
          post :create, event_id: @event.to_param, billing_detail: @billing_attrs
        end
      end
    end
    assert_redirected_to event_path(@event)
    
    ca = ChargeAttempt.last
    assert ca.success?
    
    pr = Purchase.last
    assert @event.reload.purchased?
    assert_equal @user, pr.user
    assert_equal @event, pr.event
    assert_equal ca, pr.charge_attempt
    assert_equal 19900, pr.charge_attempt.amount
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
  
  test "landing page price shows on new page" do
    #imitate landing on homepage with a different price
    # 51c causes insufficient funds in Rails.env.test. See purchase_test.rb
    lp = Factory(:landing_page, price: 9951)
    session[:landing_page] = lp.path
    
    get :new, event_id: @event.to_param
    assert_select "#price", "USD$99"
  end
  
  test "transaction failure returns to new page" do
    lp = Factory(:landing_page, price: 9951)
    session[:landing_page] = lp.path
    
    assert_difference "BillingDetail.count" do
      assert_no_difference "Purchase.count" do
        assert_difference "ChargeAttempt.count" do
          post :create, event_id: @event.to_param, billing_detail: @billing_attrs
        end
      end
    end
    assert_template :new
    assert_equal "Sorry, you have insufficient funds on this card", flash[:error]
    
  end
  
end
