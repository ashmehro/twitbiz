class CreatePurchases < ActiveRecord::Migration
  def self.up
    create_table :purchases do |t|
      t.string :deal_id
      t.string :tweet_id
      t.string :user_id
      t.string :org_id
      t.datetime :bought_on
      t.integer :count
      t.text :details

      t.timestamps
    end
  end

  def self.down
    drop_table :purchases
  end
end
