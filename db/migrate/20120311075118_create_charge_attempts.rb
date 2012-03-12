class CreateChargeAttempts < ActiveRecord::Migration
  def change
    create_table :charge_attempts do |t|
      t.references :billing_detail
      t.boolean :success
      t.string :message
      t.string :authorization
      t.integer :amount

      t.timestamps
    end
    add_index :charge_attempts, :billing_detail_id
  end
end
