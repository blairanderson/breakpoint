class AddActiveToTeamMembers < ActiveRecord::Migration
  def change
    add_column :team_members, :active, :boolean, default: true, null: false
  end
end
