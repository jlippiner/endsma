class ReportsController < ApplicationController
  layout "reports"

  def index
    @output = Clicks.find(:all, :order => "created_at")
    @groups = Clicks.find_by_sql("SELECT referral, tags, count(*) AS Visits FROM clicks GROUP BY referral, tags ORDER BY count(*) DESC")
  end


end
