class Device < ActiveRecord::Base
  
  has_many :photos
  
  validates :guid, presence: {allow_blank: false}
  
end
