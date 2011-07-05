class CreateMembers < ActiveRecord::Migration
  def self.up
    create_table :members do |t|
      t.string :name
      t.string :twitter_id
      t.string :twitter_handle
      t.string :full_name
      t.string :auth_token
      t.string :auth_token_secret
      t.string :profile_image_url

      t.timestamps
    end
  end

  def self.down
    drop_table :members
  end
end
