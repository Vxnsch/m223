class BackfillAndRequireRoleOnUsers < ActiveRecord::Migration[8.1]
  def up
    execute <<~SQL.squish
      UPDATE users
      SET role = 'user'
      WHERE role IS NULL OR role = ''
    SQL

    change_column_null :users, :role, false
  end

  def down
    change_column_null :users, :role, true
  end
end
