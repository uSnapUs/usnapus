require 'test_helper'

class BillingDetailTest < ActiveSupport::TestCase

  setup do
    @bd = Factory.create(:billing_detail)
    @random_currency = %w(USD NZD).sample
  end

  test "card needs number" do
    bd = Factory.build(:billing_detail, number: nil)
    assert !bd.valid?, "Card should not be valid without number"
    assert_not_nil bd.errors[:number]
  end

  # To return the appropriately mapped response you must append each 
  # purchase amount with a cents amount that correlates as below. 
  # The dollar amount is not relevant.
  # 
  #   .00 - Approved (Response Code 0)
  #   .51 - Insufficient Funds (Response Code 5)
  #   .12 - Invalid Transaction (Response Code 8)
  #   .54 - Expired Card (Response Code 4)
  #   .91 - Error communicating with Bank (Response Code 6)

  test "charge a valid card where it will succeed" do
   assert_difference "ChargeAttempt.count" do
      charge_attempt = @bd.charge(9900, @random_currency)
      assert_equal 9900, charge_attempt.amount
      assert_equal @random_currency, charge_attempt.currency
      assert_equal "0", charge_attempt.error_code
      assert charge_attempt.success
      assert_nil charge_attempt.message
    end
  end
  
  test "attempt to charge a card where they have insufficient funds" do
    assert_difference "ChargeAttempt.count" do
      charge_attempt = @bd.charge(9951, @random_currency)
      assert_equal 9951, charge_attempt.amount
      assert_equal @random_currency, charge_attempt.currency
      assert !charge_attempt.success, "The transaction should not be successful"
      assert charge_attempt.declined, "The card should have declined"
      assert_equal "Insufficient funds", charge_attempt.message
      assert_equal "5", charge_attempt.error_code
    end
  end
  
  test "attempt to charge a card where there is an invalid transaction" do
    assert_difference "ChargeAttempt.count" do
      charge_attempt = @bd.charge(9912, @random_currency)
      assert_equal 9912, charge_attempt.amount
      assert_equal @random_currency, charge_attempt.currency
      assert !charge_attempt.success, "The transaction should not be successful"
      assert charge_attempt.declined, "The card should have declined"
      assert_equal "Transaction type not supported", charge_attempt.message
      assert_equal "8", charge_attempt.error_code
    end
  end
  
  test "attempt to charge a card where their card has expired" do
    assert_difference "ChargeAttempt.count" do
      charge_attempt = @bd.charge(9954, @random_currency)
      assert_equal 9954, charge_attempt.amount
      assert_equal @random_currency, charge_attempt.currency
      assert !charge_attempt.success, "The transaction should not be successful"
      assert charge_attempt.declined, "The card should have declined"
      assert_equal "Expired card", charge_attempt.message
      assert_equal "4", charge_attempt.error_code
    end
  end
  
  test "attempt to charge a card where there is an error communicating with bank" do
    assert_difference "ChargeAttempt.count" do
      charge_attempt = @bd.charge(9991, @random_currency)
      assert_equal 9991, charge_attempt.amount
      assert_equal @random_currency, charge_attempt.currency
      assert !charge_attempt.success, "The transaction should not be successful"
      assert charge_attempt.declined, "The card should have declined"
      assert_equal "Error communicating with bank", charge_attempt.message
      assert_equal "6", charge_attempt.error_code
    end
  end
  
  test "card strips out spaces" do
    bd  =  Factory.build(:billing_detail, number: "4111 1111 1111 1111")
    assert bd.valid?, bd.errors.full_messages.to_sentence
    assert_equal "4111111111111111", bd.to_credit_card.number
  end

  test "last four digits and card type saved" do
    bd = Factory(:billing_detail)
    assert_equal "8769", bd.last_four_digits
    assert_equal "Visa", bd.card_type
    assert_equal "Visa ending in 8769", bd.description
  end
  
end
