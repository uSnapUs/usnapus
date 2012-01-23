class RemoveDeviceGuidAndDeviceNameFromPhotos < ActiveRecord::Migration
  def up
    remove_column :photos, :device_guid
    remove_column :photos, :device_name
    add_column :photos, :device_id, :integer
  end

  def down
    add_column :photos, :device_guid, :string
    add_column :photos, :device_name, :string
    remove_column :photos, :integer, :device_id
  end
end
