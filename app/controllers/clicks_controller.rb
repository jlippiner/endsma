class ClicksController < ApplicationController
  def new
    if Clicks.create(:referral => params[:ref], :tags => params[:tags], :ip_address => request.remote_ip, :useragent => request.env['HTTP_USER_AGENT'] )
      redirect_to "http://www.petitiontocuresma.com"
    end
  end

end
