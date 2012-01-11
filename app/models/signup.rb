class Signup < ActiveRecord::Base
  
  after_create :sync
  
  def sync
    unless Rails.env.test? 
      CampaignMonitor.sync(self)
    end
  end
  
end
