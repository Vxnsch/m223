class CreateContentItems < ActiveRecord::Migration[8.1]
  def change
    create_table :content_items do |t|
      t.references :page, null: false, foreign_key: true
      t.string :content_type
      t.text :text
      t.string :url
      t.datetime :datetime

      t.timestamps
    end
  end
end
