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
      
      #If it is business, get its tweets else get normal consumer tweets
      if (session[:is_biz] == true)
        @tweets = client.get('statuses/user_timeline', {:count=>n, :include_entities=>1})
      else
        @tweets = client.get('statuses/home_timeline', {:count=>n, :include_entities=>1})
      end
      
      @alltweets = ""
      
      @tweets.each {
        |tweet|
        #@alltweets += tweet.id_str + "$" + tweet.user.screen_name + " - " + tweet.text + "\n\n"
        @alltweets += tweet.id_str + "$" + tweet.text 
        @deal = Deal.find(:first, :conditions=> ["tweet_id=?", tweet.id])
        if @deal != nil
          @alltweets += "$" + @deal.id.to_s
        end 
        @alltweets += "\n\n"
      } 
      respond_to do |format|
        logger.info @alltweets
        format.js {render :json =>@alltweets}
      end
    rescue => err
      logger.info "Error while getting tweets #{err}"
      redirec
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
    rescue => err
      logger.info "Unable to get the deal #{err}"
      redirect_to root_url
  end
  
  def buy
    begin
      @unique_id = '' + rand(1000000).to_s +  params[:tweetId] + rand(1000000).to_s
      @purchase = Purchase.new({:tweet_id => params[:tweetId], 
        :user_id => params[:userId], 
        :details => params[:dealText], 
        :bought_on => Time.zone.now,
        :unique_id => @unique_id})
      @purchase.save
      @qr = RQRCode::QRCode.new( @unique_id, :size => 4, :level => :h )
      render "done"
      #render :inline => "You bought the deal!"
    rescue => err
      logger.info "The deal could not be bought because: #{err}"
      render :inline => "Oops ... the deal could not be bought at this time!"
    end
  end
  
  def get_latest_tweet
    @tweet_id = ""
    begin
      client = session['twit_client']
      @url = 'statuses/user_timeline'
      @latest_tweets = client.get(@url, {:include_entities=>1, :count=>1})
      @latest_tweet = @latest_tweets[0]
      @org_id = @latest_tweet[:user][:id_str]
      @details = @latest_tweet[:text]
      @tweet_id = @latest_tweet[:id_str]
      
      if (session[:is_biz] == true)
        @deal = Deal.new({:org_id => session[:org_id], :tweet_id => @latest_tweet[:id_str],:details => @details,
                        :start_date =>Time.zone.now, :end_date=>Time.zone.now})
        @deal.save
        render :inline => "This deal has been posted - " + @details
      else
        render :inline => "Tweeted: " + @details
      end
    rescue => err
      logger.info "While saving the deal, folowing error happened: #{err}"
      render :inline => "Oops ... could not post your deal at this time" 
      #delete the tweet in case of failure
      begin
      @url = 'statuses/destroy/'+ @tweet_id
      client = session['twit_client']
      @status = client.post(@url, {:trim_user=>0, :include_entities=>1})
      rescue => err2
        render :inline => "The deal is not saved. Please delete the deal tweet." 
      end
      end
  end
    
    
end
