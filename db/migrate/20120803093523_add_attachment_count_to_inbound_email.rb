class AddAttachmentCountToInboundEmail < ActiveRecord::Migration
  def change
    add_column :inbound_emails, :attachment_count, :integer

  end
end
