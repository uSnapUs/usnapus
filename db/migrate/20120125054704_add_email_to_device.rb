class AddEmailToDevice < ActiveRecord::Migration
  def change
    add_column :devices, :email, :string
  end
end
