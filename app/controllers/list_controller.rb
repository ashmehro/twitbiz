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
        config.oauth_token = session[:oauth_token]
        config.oauth_token_secret = session[:oauth_token_secret]
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
      if session['twit_client'] == nil || session['twit_client'].oauth_token == nil
      Twitter.configure do |config|
        config.consumer_key = Rails.application.config.consumer_key
        config.consumer_secret = Rails.application.config.consumer_secret
        config.oauth_token = session['access_token']['oauth_token']
        config.oauth_token_secret = session['access_token']['oauth_token_secret']
      end

      client = Twitter::Client.new
      session['access_token'] = ""
      session['twit_client'] = client
      else
        client = session['twit_client']
      end
      n = params[:count]
      #n = 2
      
      @tweets = client.get('statuses/home_timeline', {:count=>n, :include_entities=>1})
      @alltweets = ""
      @tweets.each {
        |tweet|
        #@alltweets += tweet.id_str + "$" + tweet.user.screen_name + " - " + tweet.text + "\n\n"
        @alltweets += tweet.id_str + "$" + tweet.text + "\n\n" 
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

  def usetweet
    begin
      begin  
      client = session['twit_client']
        @tweet_id = params[:tweet_id]
        @url = 'statuses/show/' + @tweet_id

        @status = client.get(@url, {:trim_user=>0, :include_entities=>1})

        rescue
        puts "Unable to get status, get another client"
        Twitter.configure do |config|
          config.consumer_key = Rails.application.config.consumer_key
          config.consumer_secret = Rails.application.config.consumer_secret
          config.oauth_token = session['twit_client']['oauth_token']
          config.oauth_token_secret = session['twit_client']['oauth_token_secret']
        end
        client = Twitter::Client.new
        session['twit_client'] = client
        @status = client.get(@url, {:trim_user=>0, :include_entities=>1})
      end
    end
    rescue
      render :inline => "Cannot make connection with twitter API "   
  end
  
  def buy
    @tweet = Tweet.new
    Tweet.update()
  end
  
  def get_latest_tweet
    begin
    #  client = session['twit_client']
    #  @url = 'statuses/user_timeline'
    #  @latest_tweet = client.get(@url, {:include_entities=>1, :count=>1})
    #  @deal = Deal.new({:org_id => @latest_tweet.params[:user][:id_str], :details => @access_token.params[:text],
    #                  :start_date =>Time.zone.now, :end_date=>Time.zone.now})
    #  @deal.save
    rescue
    #  puts "cannot get the latest tweet or not save the deal" 
    end
  end
    
    
end
