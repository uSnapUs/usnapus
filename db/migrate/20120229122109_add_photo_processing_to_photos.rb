class AddPhotoProcessingToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :photo_processing, :boolean, default: true
  end
end
