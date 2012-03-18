class InboundEmail < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :event
  has_many :photos
  
  validates :event, presence: true
  validates :to, presence: {allow_blank: nil}
  validates :message_id, presence: {allow_blank: nil}, uniqueness: true
  
  before_validation :assign_event, on: :create
  
  attr_accessible :to, :from, :name
  
  private
    def assign_event
      if code = to.try(:split, /@/).try(:first)
        self.event_id = Event.find_by_code(code.upcase).try(:id)
      end
    end
        
  
end
