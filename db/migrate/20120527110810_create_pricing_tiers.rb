class CreatePricingTiers < ActiveRecord::Migration
  def change
    create_table :pricing_tiers do |t|
      t.integer :price_nzd
      t.integer :price_usd

      t.timestamps
    end
  end
end
