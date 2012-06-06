class AddPricingTierToEvent < ActiveRecord::Migration
  def change
    add_column :events, :pricing_tier_id, :integer
  end
end
