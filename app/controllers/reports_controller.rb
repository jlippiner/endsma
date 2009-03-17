class ReportsController < ApplicationController
  layout "reports"

  def index
    get_dates
    @output = Clicks.find(:all, :order => "created_at DESC", :conditions => {:created_at => @sdate..@edate } )
    @groups = Clicks.find_by_sql(["SELECT referral, tags, count(*) AS Visits FROM clicks WHERE created_at BETWEEN ? AND ? GROUP BY referral, tags ORDER BY count(*) DESC",@sdate,@edate])

    @options = ['Today','Yesterday','This Week','This Month','Last Month','Custom']
  end

  def get_dates
    @val = params[:daterange]
    @val ||= 'Yesterday'
    case @val
    when 'Today'
      @sdate = @edate = Date.today
    when 'Yesterday'
      @sdate = @edate = Date.today - 1
    when 'This Week'
      @sdate = Date.today - Time.now.wday
      @edate = Date.today
    when 'This Month'
      @sdate = Date.today - Date.today.day + 1
      @edate = Date.today
    when 'Last Month'
      @sdate = (Date.today << 1) - Date.today.day + 1
      @edate = Date.today - Date.today.day 
    when 'Custom'
      @sdate = Time.parse(params[:sdate]).to_date
      @edate = Time.parse(params[:edate]).to_date
    else
      @sdate = '2009-03-12'.to_date
      @edate = Date.today
    end
  end


end
