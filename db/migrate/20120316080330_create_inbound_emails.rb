class CreateInboundEmails < ActiveRecord::Migration
  def change
    create_table :inbound_emails do |t|
      t.string :from
      t.string :to
      t.string :name
      t.references :user
      t.references :event
      t.string :message_id

      t.timestamps
    end
    add_index :inbound_emails, :user_id
    add_index :inbound_emails, :event_id
  end
end
