class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :name
      t.string :location
      t.date :start_date
      t.date :end_date
      t.string :start_time
      t.string :end_time
      t.integer :user_id
      t.integer :capacity
      t.integer :status
      t.boolean :active

      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
