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
    redirect_to '/list/index'
    
    case response
      when Net::HTTPSuccess
        puts response.body
      else
        puts "error in getting credentials"
      end
      rescue => err
        puts "Exception in verify_credentials: #{err}"
  end
    
  def logout
    #self.current_user = false 
    session = nil
    flash[:notice] = "You have been logged out."
    redirect_to root_url
  end
  
  def new
    
    @consumer_key = Rails.application.config.consumer_key
    @consumer_secret = Rails.application.config.consumer_secret
    @callback_url = "http://bit.ly/jUm4Ab" #for /login/authorized
    @consumer = OAuth::Consumer.new(@consumer_key, @consumer_secret, {
      :site               => "https://api.twitter.com",
      :scheme             => :header,
      :http_method        => :post,
      :request_token_path => "/oauth/request_token",
      :access_token_path  => "/oauth/access_token",
      :authorize_path     => "/oauth/authorize",
      #:authorize_url      => "https://api.twitter.com/oauth/authorize",
      #:authenticate_url   => "https://api.twitter.com/oauth/authenticate",
      :oauth_callback_url => "http://bit.ly/jUm4Ab", # for /login/authorized
      :oauth_nonce => OAuth::Helper.generate_key(64),
      :oauth_signature_method => "HMAC-SHA1",
      :oauth_timestamp => OAuth::Helper.generate_timestamp
      
    })
    
    @request_token = @consumer.get_request_token(:oauth_callback => @callback_url)
    session[:request_token] = @request_token
    #session[:oauth_token] = @request_token.params['oauth_token']
    #session[:oauth_token_secret] = @request_token.params['oauth_token_secret']
    #session[:consumer] = @consumer
    @auth_url = @consumer.authorize_url + "?oauth_token=" + @request_token.token
    redirect_to @auth_url
    
    rescue
      # The user might have rejected this application. Or there was some other error during the request.
      RAILS_DEFAULT_LOGGER.error "Failed to login via OAuth"
      flash[:error] = "Twitter API failure (account login)"
      redirect_to root_url
  end
  
end
