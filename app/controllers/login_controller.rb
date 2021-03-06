require 'uri'

class LoginController < ApplicationController
  def index
    #if session['access_token'] != nil
    #  authorized
    #end
  end
  
  def access_token
    self.access_token
  end
  
  def authorized
    @request_token = session[:request_token]
    
    @oauth_nonce = OAuth::Helper.generate_key(64)
                                                        
    @access_token = @request_token.get_access_token ({ :oauth_consumer_key => Rails.application.config.consumer_key,
                                                      :oauth_nonce => @oauth_nonce,
                                                      :oauth_signature_method => "HMAC-SHA1", 
                                                      :oauth_timestamp => OAuth::Helper.generate_timestamp,
                                                      :oauth_token => session[:oauth_token],
                                                      :oauth_token_secret => session[:oauth_token_secret],
                                                      :oauth_version => "1.0"
                                                    })
    session[:request_token] = ""
    session[:consumer] = ""
    @length = @access_token.to_s.length
    session['access_token'] = @access_token.params
    response = @access_token.get('/account/verify_credentials.json')
    @member = Member.find(:first, :conditions =>["twitter_id = ?", @access_token.params[:user_id]])
    if (@member == nil)
      @member = Member.new({:twitter_id => @access_token.params[:user_id], :twitter_handle => @access_token.params[:screen_name],
                      :auth_token =>@access_token.params[:oauth_token], :auth_token_secret=>@access_token.params[:oauth_token_secret]})
      session[:noemail] = true
      @member.save
    else
      Member.update(@member.id, {:auth_token =>@access_token.params[:oauth_token], :auth_token_secret=>@access_token.params[:oauth_token_secret]})
    end
    session[:user_id] = @member.id
    is_login_business(@member[:twitter_handle])
    redirect_to '/list/index'
    
    case response
      when Net::HTTPSuccess
        puts response.body
      else
        puts "error in getting credentials"
      end
      rescue => err
        render :inline=> "Exception in verify_credentials: #{err}"
  end
  
  def update_email
    begin
      @email = params[:email]
      Member.update(session[:user_id], {:email => @email})
      session[:noemail] = false
    rescue => err
        logger.info "User could not update the email address #{@email} because of #{err}"
    end  
  end
    
  def logout
    #self.current_user = false 
    reset_session #session = nil
    flash[:notice] = "You have been logged out."
    redirect_to root_url
  end
  
  def new
    session[:email] = params[:email]
    @consumer_key = Rails.application.config.consumer_key
    @consumer_secret = Rails.application.config.consumer_secret
    @callback_url = "http://bit.ly/jUm4Ab" 
    @consumer = OAuth::Consumer.new(@consumer_key, @consumer_secret, {
      :site               => "https://api.twitter.com",
      :scheme             => :header,
      :http_method        => :post,
      :request_token_path => "/oauth/request_token",
      :access_token_path  => "/oauth/access_token",
      :authorize_path     => "/oauth/authorize",
      :oauth_callback_url => "http://bit.ly/jUm4Ab", # for /login/authorized
      :oauth_nonce => OAuth::Helper.generate_key(64),
      :oauth_signature_method => "HMAC-SHA1",
      :oauth_timestamp => OAuth::Helper.generate_timestamp
      
    })
    
    @request_token = @consumer.get_request_token(:oauth_callback => @callback_url)
    session[:request_token] = @request_token

    @auth_url = @consumer.authorize_url + "?oauth_token=" + @request_token.token
    redirect_to @auth_url
    
    rescue
      # The user might have rejected this application. Or there was some other error during the request.
      RAILS_DEFAULT_LOGGER.error "Failed to login via OAuth"
      flash[:error] = "Twitter API failure (account login)"
      redirect_to root_url
  end

  def is_login_business (twit_handle)
    #search for the login in org
    @org = Org.find(:first, :conditions =>["handle = ?", twit_handle])
    if (@org != nil)
      session[:is_biz] = true
      session[:org_id] = @org.id
    else
      session[:is_biz] = false
    end
  end
end
