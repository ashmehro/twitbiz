class AddLatLangToOrgs < ActiveRecord::Migration
  def self.up
    add_column :orgs, :latitude, :float
    add_column :orgs, :longitude, :float
  end

  def self.down
    remove_column :orgs, :latitude
    remove_column :orgs, :longitude
  end
end
