class CreateActivityLogs < ActiveRecord::Migration[8.1]
  def change
    create_table :activity_logs do |t|
      t.references :user, null: false, foreign_key: true
      t.string :action
      t.string :subject_type
      t.integer :subject_id
      t.text :details

      t.timestamps
    end
  end
end
