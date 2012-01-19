class AddCodeToEvents < ActiveRecord::Migration
  def change
    add_column :events, :code, :string
    add_index :events, :code, unique: true
  end
end
