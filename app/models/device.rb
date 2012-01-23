class Device < ActiveRecord::Base
  
  validates :guid, presence: {allow_blank: false}
  
end
