class RenamePlayersToTeamMembers < ActiveRecord::Migration
  def up
    rename_table 'players', 'team_members'
  end

  def down
    rename_table 'team_members', 'players'
  end
end

