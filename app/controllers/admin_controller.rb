class AdminController < ApplicationController
  before_filter :verify_password
  def stats
    render :json=> stats_obj(params[:type],params[:period])
  end
  def stats_geckoboard
    render :json=> to_geco(stats_obj(params[:type],params[:period]))
  end
  private
    def verify_password
     authenticate_or_request_with_http_basic do |user, password|
        (user == "ADMIN" && password == "1fQwIEET0cBcDK") ||
        (user == "7L2RiQAo767hgCGriG2keVPuFjtG" && password == "X")
      end
    end
  private

  def to_geco(stats)
    geco_stats = {
      :item=>Array.new,
      :settings=>{
        :axisx=>Array.new,
        :axisy=>Array.new,
        :colour=>"70D4A0"
      }
    }
    max =0;
    min=0
    stats.each do |stat|
      max = stat[1] if (stat[1]>max)
      geco_stats[:settings][:axisx]<<stat[0]
      geco_stats[:item]<<stat[1]
    end
    
    geco_stats[:settings][:axisy]<<min
    geco_stats[:settings][:axisy]<<max
    return geco_stats
  end

  def stats_obj(type,period)
    limit = 1.day.ago.utc.to_s
    grouping = "DATE(created_at)"
    data_hash={};
    case(period.downcase)
      when "year"
        limit = 1.year.ago.utc.to_date.to_s
        data_hash = year_hash
        grouping = "DATE_FORMAT(created_at,'%Y-%m')"
      when "month"
        limit = 1.month.ago.utc.to_date.to_s
        data_hash = month_hash
        grouping = "DATE(created_at)"
      when "week"
        limit = (1.week.ago.utc.to_date).to_s
        data_hash = week_hash
        grouping = "DAYNAME(created_at)" 
      when "day"
        limit = (24.hours.ago.utc+1.hour).to_s
        grouping = "HOUR(created_at)" 
        data_hash= day_hash
    end
    table = type.downcase+"s"
    query = "SELECT COUNT(1) as count, #{grouping} as date  FROM #{table} WHERE created_at > '#{limit}' GROUP BY #{grouping}"

    ActiveRecord::Base.connection.execute("#{query}").each(:as => :hash) do |row|
       data_hash[row["date"].to_s.downcase]=row["count"]
    end
    return data_hash
  end

  def year_hash
    data = {}
    currDate = 1.year.ago.utc.to_date
    while(currDate<=DateTime.now.utc.to_date) do
      data[currDate.strftime("%Y-%m")]=0
      currDate+=1.month
    end
    return data
  end
  def month_hash
    data = {}
    currDate = 1.month.ago.utc.to_date
    while(currDate<=DateTime.now.utc.to_date) do
      data[currDate.strftime]=0
      currDate+=1
    end
    return data
  end
  def week_hash
    data = {}
    currDate = 1.week.ago.utc.to_date+1
    while(currDate<=DateTime.now.utc.to_date) do
      data[currDate.strftime("%A").downcase]=0
      currDate+=1
    end
    return data
  end
  def day_hash
    data = {}
    curr_hour = 1.day.ago.utc.hour+1
    if(curr_hour==24)
       curr_hour=0
    end
    begin 
      data[curr_hour]=0
      curr_hour+=1
      if(curr_hour==24)
        curr_hour=0
      end
    end until curr_hour===DateTime.now.utc.hour
    data[curr_hour]=0
    return data
  end
end
