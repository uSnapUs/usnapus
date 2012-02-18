class AddS3TokenToEvents < ActiveRecord::Migration
  def change
    add_column :events, :s3_token, :string
  end
end
