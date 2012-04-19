class CreateLandingPages < ActiveRecord::Migration
  def change
    create_table :landing_pages do |t|
      t.string :path
      t.text :body_html
      t.integer :price

      t.timestamps
    end
  end
end
