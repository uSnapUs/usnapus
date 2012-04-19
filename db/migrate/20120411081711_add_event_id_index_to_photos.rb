class AddEventIdIndexToPhotos < ActiveRecord::Migration
  def change
    add_index :photos, :event_id
  end
end
