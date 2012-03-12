require 'test_helper'

class BillingDetailTest < ActiveSupport::TestCase

  test "card needs number" do
    bd = Factory.build(:billing_detail, number: nil)
    assert !bd.valid?, "Card should not be valid without number"
    assert_not_nil bd.errors[:number]
  end

  test "charge a valid card" do
    bd = Factory.create(:valid_paypal_billing_detail)
    
    assert_difference "ChargeAttempt.count" do
      charge_attempt = bd.charge("127.0.0.1")
      assert_equal 9900, charge_attempt.amount
      assert_equal "USD", charge_attempt.currency
      assert charge_attempt.success
      assert_nil charge_attempt.message
    end
  end
  
  test "attempt to charge a card where it fails" do
    bd = Factory.create(:invalid_paypal_billing_detail)
    
    assert_difference "ChargeAttempt.count" do
      charge_attempt = bd.charge("127.0.0.1")
      assert_equal 9900, charge_attempt.amount
      assert_equal "USD", charge_attempt.currency
      assert !charge_attempt.success
      assert_not_nil charge_attempt.message
    end
  end
  
  test "can't charge an account without an ip" do
    bd = Factory.create(:valid_paypal_billing_detail)
    
    assert_nil bd.charge("")
    assert_nil bd.charge(nil)
  end

  test "card strips out spaces" do
    bd  =  Factory.build(:billing_detail, number: "4111 1111 1111 1111")
    assert bd.valid?, bd.errors.full_messages.to_sentence
    assert_nil bd.errors[:number]
    assert_equal "4111111111111111", bd.to_credit_card.number
  end

  test "last four digits and card type saved" do
    bd = Factory(:billing_detail, card_type: "Visa")
    assert_equal "1111", bd.last_four_digits
    assert_equal "Visa", bd.card_type
    assert_equal "Visa ending in 1111", bd.description
  end
  
end
