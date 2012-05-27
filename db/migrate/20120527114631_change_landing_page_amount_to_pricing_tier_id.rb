class ChangeLandingPageAmountToPricingTierId < ActiveRecord::Migration
  def change
    remove_column :landing_pages, :price
    add_column    :landing_pages, :pricing_tier_id, :integer
  end
end
