class CreateSignups < ActiveRecord::Migration
  def change
    create_table :signups do |t|
      t.datetime :event_date
      t.string :email

      t.timestamps
    end
  end
end
