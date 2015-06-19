class AddDestroyedAt < ActiveRecord::Migration
  def up
    add_column :users,                :destroyed_at, :datetime
    add_column :teams,                :destroyed_at, :datetime
    add_column :team_members,         :destroyed_at, :datetime
    add_column :matches,              :destroyed_at, :datetime
    add_column :match_availabilities, :destroyed_at, :datetime
    add_column :match_lineups,        :destroyed_at, :datetime
    add_column :match_players,        :destroyed_at, :datetime
    add_column :match_sets,           :destroyed_at, :datetime
    add_column :practices,            :destroyed_at, :datetime
    add_column :practice_sessions,    :destroyed_at, :datetime
    remove_index :users, :email
    add_index    :users, :email, unique: true, where: "destroyed_at IS NULL"
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
