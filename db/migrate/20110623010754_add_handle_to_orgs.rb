class AddHandleToOrgs < ActiveRecord::Migration
  def self.up
    add_column :orgs, :handle, :string 
  end

  def self.down
    remove_column :orgs, :handle
  end
end
