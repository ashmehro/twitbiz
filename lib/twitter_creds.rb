#Use this module to login and logout from Twitter and all the intermediate stages of authentication and authorization
require 'oauth'

module TwitterCreds
  
  def callback_url
    callback_url
  end
  
  def consumer_key
    consumer_key
  end
  
  def request_token
    @request_token
  end
  
  def consumer_secret
    consumer_secret
  end
 
  def oauth_login_required
    logged_in? || login_by_oauth
  end
  
  def logged_in?
    !!current_user
  end

   def current_user
    @current_user ||= (login_from_session) unless @current_user == false
    end
    
  def login_from_session
    current_user = Member.find_by_twitter_id(session[:twitter_id]) if session[:twitter_id]
  end
    
  def initialize( user_token = nil, user_secret = nil )
    @consumer_key = Rails.application.config.consumer_key
    @consumer_secret = Rails.application.config.consumer_secret
    #@callback_url = "http://bit.ly/iLspBw" for /list/index
    @callback_url = "http://bit.ly/jUm4Ab" #for /login/authorized
    @consumer = OAuth::Consumer.new(@consumer_key, @consumer_secret, {
      :site               => "https://api.twitter.com",
      :scheme             => :header,
      :http_method        => :post,
      :request_token_path => "/oauth/request_token",
      :access_token_path  => "/oauth/access_token",
      :authorize_path     => "/oauth/authorize",
      :authorize_url      => "https://api.twitter.com/oauth/authorize",
      #:authenticate_url   => "https://api.twitter.com/oauth/authenticate",
      :oauth_callback_url => "http://bit.ly/iLspBw" # for /list/index
    })
    
    @request_token = @consumer.get_request_token(:oauth_callback => @callback_url)
    #session[:request_token] = @request_token
  end
  
  def login_by_oauth
    #initialize
    @auth_url = @consumer.authorize_url + "?oauth_token=" + @request_token.token
    redirect_to @auth_url
    
    rescue
      # The user might have rejected this application. Or there was some other error during the request.
      RAILS_DEFAULT_LOGGER.error "Failed to login via OAuth"
      flash[:error] = "Twitter API failure (account login)"
      redirect_to root_url
   
  end
  
  def callback
    self.exchange_request_for_access_token( @request_token, @request_token.secret, params[:oauth_verifier] )
  end
  
  def access_token( user_token = nil, user_secret = nil )
    ( user_token && user_secret ) ? @access_token = OAuth::AccessToken.new( self.consumer, user_token, user_secret ) : @access_token
  end
  
  def access_token=(new_access_token)
    @access_token = new_access_token || false
  end
  
  def exchange_request_for_access_token( request_token,  request_token_secret, oauth_verifier )
    #request_token = self.request_token( request_token, request_token_secret )
    request_token = OAuth::RequestToken.new(@consumer, request_token, request_token_secret)
    #Exchange the request token for an access token. this may get 401 error
    self.access_token = request_token.get_access_token( :oauth_verifier => oauth_verifier )
  rescue => err
    puts "Exception in exchange_request_for_access_token: #{err}"
    raise err
  end
  
  # controller method to handle logout
  def logout
    self.current_user = false 
    flash[:notice] = "You have been logged out."
    redirect_to root_url
  end
  
  
  
  def get_current_user
    Twitter.configure do |config|
        config.consumer_key = Rails.application.config.consumer_key
        config.consumer_secret = Rails.application.config.consumer_secret
        #config.oauth_token = Rails.application.config.oauth_token
        #config.oauth_token_secret = Rails.application.config.oauth_token_secret
      end
      client = Twitter::Client.new
      return client
  end
  
end