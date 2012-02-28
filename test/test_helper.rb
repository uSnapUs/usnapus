ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'mocha'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
  
  def unprotected_attributes(obj)
    attributes = {}
    obj._accessible_attributes[:default].each do |attribute|
      attributes[attribute] = obj.send(attribute) unless attribute.blank?
    end
    attributes
  end
  
end