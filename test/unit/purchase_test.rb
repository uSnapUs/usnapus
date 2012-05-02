require 'test_helper'

class PurchaseTest < ActiveSupport::TestCase
  
  setup do
    @event = Factory(:event)
    @user = Factory(:user)
    @billing_detail = Factory.create(:billing_detail)
  end
  
  test "can purchase an event" do
    assert !@event.purchased?
    purchase = @user.purchase(@event, @billing_detail, 9900, "NZD")
    assert purchase.valid?, "Purchase should be valid"
    assert purchase.persisted?
    @event.reload
    assert_equal @event, purchase.event
    assert @event.purchased?, "Event should be purchased"
  end
  
  test "purchasing an event creates a charge attempt" do
    assert_difference "ChargeAttempt.count" do
      purchase = @user.purchase(@event, @billing_detail, 9900, "NZD")
      ca = ChargeAttempt.last
      assert_equal ca, purchase.charge_attempt
      assert_equal 9900, ca.amount
      assert_equal "NZD", ca.currency
      assert_equal @billing_detail, ca.billing_detail
    end
  end
  
  test "when a purchase fails due to card it creates a charge attempt and purchase with card errors" do
    assert_difference "ChargeAttempt.count" do
      purchase = @user.purchase(@event, @billing_detail, 9951, "NZD")
      assert_equal ["Insufficient funds"], purchase.errors[:credit_card]
      assert !purchase.persisted?
    end
    assert !@event.purchased?
  end
  
  test "can't purchase in a foreign currency" do
    assert_no_difference "ChargeAttempt.count" do
      assert @user.purchase(@event, @billing_detail, 9900, "AUD").invalid? 
    end
  end
  
  test "can't purchase an event twice by the same user" do
    @user.purchase(@event, @billing_detail, 9900, "NZD")
    
    assert_no_difference "ChargeAttempt.count" do
      purchase = @user.purchase(@event, @billing_detail, 9900, "NZD")
      assert purchase.invalid?
      assert_equal ["has already been purchased"], purchase.errors[:event_id]
    end
  end
  
  test "can't purchase an event twice by another user" do
    @user.purchase(@event, @billing_detail, 9900, "NZD")
    
    assert_no_difference "ChargeAttempt.count" do
      purchase = Factory(:user).purchase(@event, Factory.create(:billing_detail), 9900, "NZD")
      assert purchase.invalid?
      assert_equal ["has already been purchased"], purchase.errors[:event_id]
    end
  end
  
end