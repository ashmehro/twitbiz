class AddUniqueIdToPurchases < ActiveRecord::Migration
  def self.up
    add_column :purchases, :unique_id, :string
  end

  def self.down
    remove_column :purchases, :unique_id
  end
end
