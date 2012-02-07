class Device < ActiveRecord::Base
  
  has_many :photos
  
  validates :guid, presence: {allow_blank: false}
  validates :name, presence: {allow_blank: false}
  validate :forbid_changing_guid, on: :update
  
  attr_accessible :guid, :name, :email

  private
  
    def forbid_changing_guid
      errors[:guid] = "can't be changed" if self.guid_changed?
    end
  
end
