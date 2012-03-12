class CreateBillingDetails < ActiveRecord::Migration
  def change
    create_table :billing_details do |t|
      t.references :user
      t.string :card_type
      t.string :card_name
      t.string :last_four_digits

      t.timestamps
    end
    add_index :billing_details, :user_id
  end
end
