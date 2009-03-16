class ClicksController < ApplicationController
  layout false

  def new
    if Clicks.create(:referral => params[:ref], :tags => params[:tags], :ip_address => request.remote_ip, :useragent => request.env['HTTP_USER_AGENT'] )
      redirect_to "http://www.thepetitionsite.com/182/petition-to-cure-SMA"
    end
  end
  
end
