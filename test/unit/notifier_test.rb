require 'test_helper'

class NotifierTest < ActionMailer::TestCase
  
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
    lp = Factory :landing_page, path: "test", price: 4900
    user = Factory :user, email: "nick@usnap.us", name: "Nick Malcolm"
    event = Factory :event, name: "Nick's Party", code: "nicks", free: false, landing_page: lp
    email = Notifier.upgrade(user, event).deliver
    assert_match "They came from the landing page at \"test\" and should be invoiced for US$49", email.encoded
  end
  
end