class AddFieldsToChargeAttempts < ActiveRecord::Migration
  def change
    add_column :charge_attempts, :currency, :string
    add_column :charge_attempts, :transaction_identifier, :string
    add_column :charge_attempts, :merchant_session, :string
    add_column :charge_attempts, :error_code, :string
    add_column :charge_attempts, :declined, :boolean
  end
end
