class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :guid
      t.string :name

      t.timestamps
    end
  end
end
