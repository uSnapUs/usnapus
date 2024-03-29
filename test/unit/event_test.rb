require 'test_helper'

class EventTest < ActiveSupport::TestCase
  
  test "factory is valid" do
    assert Factory.build(:event).valid?
  end
  
  test "event can have photos" do
    event = Factory :event
    photo = Factory :photo, event: event 
    
    assert_equal 1, event.photos.size
    assert event.photos.include? photo
  end
  
  test "new event has code" do
    assert_match /\A[A-HJKMNP-Z2-9]{7}\Z/, Factory(:event).code
  end
  
  test "new event keeps custom code" do
    nick = Factory(:event, code: "nicks")
    assert_equal "NICKS", nick.code
    nick.save!
    assert_equal "NICKS", nick.code
  end
  
  test "new event code is parameterized" do
    assert_equal "NICK-S-1-EVENT", Factory(:event, code: "Nick's #1 Event").code
  end
  
  test "new event has an s3 token" do
    assert_equal 32, Factory(:event).s3_token.length
  end
  
  test "event code is unique" do
    new_code = Factory(:event).code
    e = Factory(:event)
    e.code = new_code
    assert e.invalid?
  end
  
  test "event code can't be in blacklist" do
    assert_not_nil Event::CODE_BLACKLIST
    
    Event::CODE_BLACKLIST.each do |blocked|
      assert Factory.build(:event, code: blocked).invalid? ,"#{blocked} should be an invalid code"
    end
  end
  
  test "pricing tier default is set by default" do
    assert_equal PricingTier::DEFAULT_PRICING_TIER, Factory(:event).pricing_tier
  end
  
  test "pricing tier is not default if set" do
    pt = Factory(:pricing_tier)
    assert_equal pt, Factory(:event, pricing_tier: pt).pricing_tier
  end
  
end
