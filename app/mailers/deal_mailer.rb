class DealMailer < ActionMailer::Base
  default :from => "edutors@edutors.com"
  
  def deal_email(purchase, qr)
    begin
      @member_id = purchase.user_id
      @member = Member.find(:first, :conditions=> ["id=?", @member_id])
      @deal = Deal.find(:first, :conditions =>["id=?", purchase.deal_id])
      @user_name = @member.full_name || @member.name || @member.twitter_handle
      @qr = qr
      @url  = "http://edutors.com"
      mail(:to => @member.email,
           :subject => "Twitbiz deal") do |format|
        format.html { render 'deal_mail' }
      end
    rescue => err
      logger.info "The deal mai could not be sent because of #{err}"
    end
  end
end
