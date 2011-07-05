class AddContactInfoToOrgs < ActiveRecord::Migration
  def self.up
    add_column :orgs, :primary_number, :string
    add_column :orgs, :landline1, :string
    add_column :orgs, :landline2, :string
    add_column :orgs, :cell1, :string
    add_column :orgs, :cell2, :string
    add_column :orgs, :fax, :string
    add_column :orgs, :primary_email, :string
    add_column :orgs, :email2, :string
    add_column :orgs, :facebook_link, :string
    add_column :orgs, :website, :string
    add_column :orgs, :notes, :text
  end

  def self.down
    remove_column :orgs, :primary_number
    remove_column :orgs, :landline1
    remove_column :orgs, :landline2
    remove_column :orgs, :cell1
    remove_column :orgs, :cell2
    remove_column :orgs, :fax
    remove_column :orgs, :primary_email
    remove_column :orgs, :email2
    remove_column :orgs, :facebook_link
    remove_column :orgs, :website
    remove_column :orgs, :notes
  end
end
