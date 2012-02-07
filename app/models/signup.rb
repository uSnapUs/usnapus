class Signup < ActiveRecord::Base
  
  validates :email, presence: {allow_blank: false}
  
  after_create :sync
  
  attr_accessible :event_date, :email
  
  def sync
    unless Rails.env.test? 
      CampaignMonitor.sync(self)
    end
  end
  
end
