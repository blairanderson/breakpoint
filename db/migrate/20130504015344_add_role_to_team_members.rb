class AddRoleToTeamMembers < ActiveRecord::Migration
  def change
    add_column :team_members, :role, :string, :default => 'member'
  end
end
