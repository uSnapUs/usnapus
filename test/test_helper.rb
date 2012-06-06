ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'mocha'

class ActiveSupport::TestCase
  
  fixtures :all
  TEST_PASSWORD = "testtest"
  
  # Add more helper methods to be used by all tests here...
  
  setup do
    Geocoder::Configuration.timeout = 0
  end
  
end
class ActionController::TestCase
  include Devise::TestHelpers
end