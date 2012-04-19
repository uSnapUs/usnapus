require 'test_helper'

class InboundEmailsControllerTest < ActionController::TestCase
  
  setup do
    @event = Factory(:current_event, code: "AWESOME")
  end
  
  teardown do
    FileUtils.rm_rf "#{Rails.root}/public/uploads/"
  end

  test "can upload photos" do
    #Have to figure out how to test...
  end
end