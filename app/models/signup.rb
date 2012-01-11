class Signup < ActiveRecord::Base
  
  after_create :sync
  
  def sync
    CampaignMonitor.sync(self)
  end
  
end
