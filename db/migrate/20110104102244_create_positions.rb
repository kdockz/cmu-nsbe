class CreatePositions < ActiveRecord::Migration
  def self.up
    create_table :positions do |t|
      t.integer :zone_id
      t.string :name
      t.string :email
      t.text :description
      t.boolean :active
      t.timestamps
    end
  end

  def self.down
    drop_table :positions
  end
end
