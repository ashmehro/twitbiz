class AddTweetIdToDeals < ActiveRecord::Migration
  def self.up
    add_column :deals, :tweet_id, :string 
  end

  def self.down
    remove_column :deals, :tweet_id
  end
end
