class ChangePhotoDeviceToCreator < ActiveRecord::Migration
  def up
    add_column :photos, :creator_type, :string
    add_column :photos, :creator_id, :integer
    
    Photo.where("device_id IS NOT ?", nil).each do |photo|
      photo.creator_type = "Device"
      photo.creator_id = photo.device_id
      photo.save!
    end
    
    remove_column :photos, :device_id
  end

  def down
    add_column :photos, :device_id, :integer
    
    Photo.where("creator_type = ?", "Device").each do |photo|
      photo.device_id = photo.creator_id
      photo.save!
    end
    
    remove_column :photos, :creator_type
    remove_column :photos, :creator_id
    
  end
end
