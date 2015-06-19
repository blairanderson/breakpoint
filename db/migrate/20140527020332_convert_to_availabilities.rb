class ConvertToAvailabilities < ActiveRecord::Migration
  def up
    rename_table :match_availabilities, :responses
    add_column :responses, :respondable_id, :integer
    add_column :responses, :respondable_type, :string
    add_index :responses, :respondable_id
    add_index :responses, :respondable_type
    ActiveRecord::Base.connection.execute "UPDATE responses SET respondable_id = match_id"
    ActiveRecord::Base.connection.execute "UPDATE responses SET respondable_type = 'Match'"
    remove_column :responses, :match_id
    ActiveRecord::Base.connection.execute "INSERT INTO responses ( user_id, created_at, updated_at, team_id, state, destroyed_at, respondable_id, respondable_type ) SELECT user_id, created_at, updated_at, team_id, CASE WHEN available = 't' THEN 'yes' ELSE 'no' END, destroyed_at, practice_id, 'Practice' FROM practice_sessions"
    drop_table :practice_sessions
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
