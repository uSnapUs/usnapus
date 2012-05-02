class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.integer :event_id
      t.integer :user_id
      t.integer :charge_attempt_id
      t.string :currency
      t.integer :amount

      t.timestamps
    end
  end
end
