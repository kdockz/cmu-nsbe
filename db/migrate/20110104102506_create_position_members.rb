class CreatePositionMembers < ActiveRecord::Migration
  def self.up
    create_table :position_members do |t|
      t.integer :position_id
      t.integer :user_id
      t.integer :start_year
      t.integer :end_year
      t.boolean :active, :default => true

      t.timestamps
    end
  end

  def self.down
    drop_table :position_members
  end
end
