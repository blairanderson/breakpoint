class AddMissingTeamIds < ActiveRecord::Migration
  def change
    add_column :match_availabilities, :team_id, :integer
    add_index :match_availabilities, :team_id
    
    add_column :match_lineups, :team_id, :integer
    add_index :match_lineups, :team_id
    
    add_column :match_players, :team_id, :integer
    add_index :match_players, :team_id
    
    add_column :match_sets, :team_id, :integer
    add_index :match_sets, :team_id
    
    add_column :practice_sessions, :team_id, :integer
    add_index :practice_sessions, :team_id

    ActiveRecord::Base.connection.execute('update match_availabilities set team_id = matches.team_id from matches where matches.id = match_availabilities.match_id')
    ActiveRecord::Base.connection.execute('update match_lineups set team_id = matches.team_id from matches where matches.id = match_lineups.match_id')
    ActiveRecord::Base.connection.execute('update match_players set team_id = match_lineups.team_id from match_lineups where match_lineups.id = match_players.match_lineup_id')
    ActiveRecord::Base.connection.execute('update match_sets set team_id = match_lineups.team_id from match_lineups where match_lineups.id = match_sets.match_lineup_id')
    ActiveRecord::Base.connection.execute('update practice_sessions set team_id = practices.team_id from practices where practices.id = practice_sessions.practice_id')
  end
end

