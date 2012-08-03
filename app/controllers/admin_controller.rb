class AdminController < ApplicationController
  before_filter :verify_password
  def stats

  end
  def feed
  	@feed = {
  		'emails_last_7_days'=>emails_last_7_days,
      'photos_in_last_7_days'=>photos_in_last_7_days,
      'attachments_last_7_days'=>attachments_last_7_days
  	}
  	render :json => @feed.as_json
  end
  private
    def verify_password
     authenticate_or_request_with_http_basic do |user, password|
        user == "ADMIN" && password == "1fQwIEET0cBcDK"
      end
    end
  private
  def emails_last_7_days
      return InboundEmail.count({:conditions => ["created_at >= ?",1.month.ago.utc.to_s]})
  end
  def photos_in_last_7_days
    return Photo.count({:conditions => ["created_at >= ? AND creator_type = ?",1.month.ago.utc.to_s,"InboundEmail"]})
  end
	def attachments_last_7_days
		return InboundEmail.sum(:attachment_count,{:conditions => ["created_at >= ?",1.month.ago.utc.to_s]})
	end
end
