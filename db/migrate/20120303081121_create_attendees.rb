class CreateAttendees < ActiveRecord::Migration
  def change
    create_table :attendees do |t|
      t.references :user
      t.references :event

      t.timestamps
    end
    add_index :attendees, :user_id
    add_index :attendees, :event_id
  end
end
