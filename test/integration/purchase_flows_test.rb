require 'test_helper'
 
class PurchaseFlowsTest < ActionDispatch::IntegrationTest
  
  setup do
    @user = Factory(:user, password: TEST_PASSWORD)
  end
  
  test "standard sign up" do
    session_for @user do
      
      assert !https?
      get "/events/new"
      assert_response :success
      
      assert_difference "Event.count" do
        post_via_redirect "/events", event: {
          location: "42 Muritai Street",
          name: "Nick's Event",
          starts: 5.days.ago,
          ends: 5.days.ago,
          code: "nicks-cool-event",
          is_public: true
        },
        redirect_to_purchase: true
      end
      event = Event.last
    
      assert_equal "/events/#{event.to_param}/purchases/new", path
      #assert https?
    
      post_via_redirect "/events/#{event.to_param}/purchases", billing_detail: {
          card_type: "Visa",
          number: "4987654321098769",
          card_name: "Testy McBob",
          month: (Date.today + 1.month).month,
          year: Date.today.year + 1,
          verification_value: "123"
        } 
      
      #assert https?
      assert_equal "/events/#{event.to_param}/photos", path  
    end
  end
  
  # test "redirects to HTTPS" do
  #     event = Factory(:event)
  #     Factory(:attendee, event: event, user: @user)
  #     
  #     session_for @user do
  #       get_via_redirect "/events/#{event.to_param}/purchases/new"
  #       assert_equal "/events/#{event.to_param}/purchases/new", path, "Should be the same page, just HTTPS"
  #       assert https?
  #     end
  #   end
  
  
  private 
    def session_for user
      post_via_redirect "/users/sign_in", user: {email: user.email, password: TEST_PASSWORD}
      assert_equal "/", path
      yield if block_given?
      delete "/users/sign_out"
    end
    
end