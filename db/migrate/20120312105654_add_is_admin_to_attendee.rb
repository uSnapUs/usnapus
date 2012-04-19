class AddIsAdminToAttendee < ActiveRecord::Migration
  def change
    add_column :attendees, :is_admin, :boolean, default: false
  end
end
