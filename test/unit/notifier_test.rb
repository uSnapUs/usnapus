require 'test_helper'

class NotifierTest < ActionMailer::TestCase
  
  test "welcome email" do
    user = Factory :user, email: "test@usnap.us", name: "Nick Malcolm"
    event = Factory :event, name: "Nick's Party", code: "nicks"
    
    email = Notifier.welcome(user, event).deliver
    assert !ActionMailer::Base.deliveries.empty?
    
    assert_equal ["test@usnap.us"], email.to
    assert_equal ["nick@usnap.us"], email.bcc
    assert_equal "Yay! Thanks for joining uSnap.us", email.subject
  end
  
  test "bulk download request" do
    user = Factory :user, email: "nick@usnap.us", name: "Nick Malcolm"
    event = Factory :event, name: "Nick's Party", code: "nicks"
    
    email = Notifier.bulk_download_request(user, event).deliver
    assert !ActionMailer::Base.deliveries.empty?
    
    assert_equal ["nick@usnap.us"], email.to
    assert_equal "Bulk download request for NICKS", email.subject
    
    assert_match /Nick Malcolm/, email.encoded
    assert_match /nick@usnap.us/, email.encoded
    assert_match /Nick's Party/, email.encoded
    assert_match /NICKS/, email.encoded
    assert_match event.s3_token, email.encoded
  end
  
  test "landing page invoice" do
    pt = Factory(:pricing_tier, price_usd: 4900)
    user = Factory :user, email: "nick@usnap.us", name: "Nick Malcolm"
    event = Factory :event, name: "Nick's Party", code: "nicks", free: false, pricing_tier: pt
    email = Notifier.upgrade(user, event).deliver
    assert_match "nick@usnap.us (Nick Malcolm) paid USD$49.0", email.encoded
  end
  
  test "forgot password" do
    user = Factory :user, email: "nick@usnap.us", name: "Nick Malcolm"
    email = Notifier.reset_password_instructions(user).deliver
    assert_equal ["nick@usnap.us"], email.to
    assert_match /Change my password/, email.encoded
  end
  
end