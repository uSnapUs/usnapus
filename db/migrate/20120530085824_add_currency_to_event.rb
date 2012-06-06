class AddCurrencyToEvent < ActiveRecord::Migration
  def change
    add_column :events, :currency, :string

  end
end
