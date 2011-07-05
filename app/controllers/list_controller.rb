class ListController < ApplicationController
  def index
    #puts "we are in list#index"
  end

  def getrealname
    begin
      val = params[:twitid]
      @user = Twitter.user(val)
      respond_to do |format|
        logger.info @user.name
        format.js {render :json =>@user.name}
      end
    rescue
      render :text => "Invalid Twitter User"
    end
  end

  def get_followers
    begin
      Twitter.configure do |config|
        config.consumer_key = Rails.application.config.consumer_key
        config.consumer_secret = Rails.application.config.consumer_secret
        config.oauth_token = Rails.application.config.oauth_token
        config.oauth_token_secret = Rails.application.config.oauth_token_secret
      end
    
      client = Twitter::Client.new
      @tweets = client.home_timeline
      @alltweets = ""
      @tweets.each {
        |tweet|
        @alltweets += tweet.text + "\n\n"
      }
      respond_to do |format|
        logger.info @alltweets
        format.js {render :json =>@alltweets}
      end
    rescue
      render :text => "No Tweet Content"
    end
  end
    
  def get_first_n_tweets
    begin
      Twitter.configure do |config|
        config.consumer_key = Rails.application.config.consumer_key
        config.consumer_secret = Rails.application.config.consumer_secret
        config.oauth_token = session['access_token']['oauth_token']
        config.oauth_token_secret = session['access_token']['oauth_token_secret']
      end
    
      client = Twitter::Client.new
      n = params[:count]
      #@tweets = client.home_timeline :count=>n, :retweeted=>true
      @tweets = client.get('statuses/home_timeline', {:count=>n, :include_entities=>1})
      @alltweets = ""
      @tweets.each {
        |tweet|
        #count = (tweet.retweet_count > 0) ? tweet.retweet_count : 0;
        #if tweet.retweet_count > 0
          @alltweets += tweet.id_str + "$" + tweet.text + "\n\n"
        #end
      }
      respond_to do |format|
        logger.info @alltweets
        format.js {render :json =>@alltweets}
      end
    rescue
      render :text => "No Tweet Content"
    end
  end
  
  def get_search_results
    begin
      search = Twitter::Search.new
      val = params[:srchterm]
      @results = search.hashtag(val).fetch.first.text
      respond_to do |format|
        logger.info @results
        format.js {render :json =>@results}
      end
    rescue
      render :text => "No search results found"
    end
  end
end
