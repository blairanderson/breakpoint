class RemoveRoleFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :role
  end

  def down
    add_column :users, :role, :null => false, :default => 'team_member'
  end
end
