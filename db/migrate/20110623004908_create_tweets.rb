class CreateTweets < ActiveRecord::Migration
  def self.up
    create_table :tweets do |t|
      t.integer :deal_id
      t.string :tweet_id
      t.string :screen_name
      t.string :real_name
      t.integer :level
      t.boolean :deal_used
      t.string :url
      t.string :data
      t.text :comments

      t.timestamps
    end
  end

  def self.down
    drop_table :tweets
  end
end
