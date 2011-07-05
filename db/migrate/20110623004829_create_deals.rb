class CreateDeals < ActiveRecord::Migration
  def self.up
    create_table :deals do |t|
      t.text :details
      t.integer :org_id
      t.integer :category_id
      t.date :start_date
      t.date :end_date
      t.boolean :is_local
      t.boolean :is_state
      t.boolean :is_national

      t.timestamps
    end
  end

  def self.down
    drop_table :deals
  end
end
