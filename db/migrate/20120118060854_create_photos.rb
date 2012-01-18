class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :photo
      t.integer :event_id
      t.string :device_guid
      t.string :device_name

      t.timestamps
    end
  end
end
