class AddLandingPageIdToEvent < ActiveRecord::Migration
  def change
    add_column :events, :landing_page_id, :integer
  end
end
