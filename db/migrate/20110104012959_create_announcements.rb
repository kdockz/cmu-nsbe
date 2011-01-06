class CreateAnnouncements < ActiveRecord::Migration
  def self.up
    create_table :announcements do |t|
      t.text :content
      t.date :start_date
      t.date :end_date
      t.boolean :active

      t.timestamps
    end
  end

  def self.down
    drop_table :announcements
  end
end
