require 'test_helper'

class LandingPagesControllerTest < ActionController::TestCase
  setup do
    @path = "test"
    @landing_page = LandingPage.create do |l|
      l.path = @path
      l.price = 49*100  # $49 in cents
      l.body_html = "<h1 class=\"test_header\">Test</h1>"
    end
  end

  test "should show landing_page" do
    get :show, path: @path
    assert_response :success
    assert_select "h1.test_header", 1
    assert_equal @path, session["landing_page"]
  end
  
end
