class AddPublicToEvents < ActiveRecord::Migration
  def change
    add_column :events, :is_public, :boolean, default: true
  end
end
