class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.float :latitude
      t.float :longitude
      t.string :name
      t.datetime :starts
      t.datetime :ends

      t.timestamps
    end
  end
end
