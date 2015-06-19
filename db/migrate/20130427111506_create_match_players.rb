class CreateMatchPlayers < ActiveRecord::Migration
  def up
    create_table :match_players do |t|
      t.references :user
      t.references :match_lineup

      t.timestamps
    end
    add_index :match_players, :user_id
    add_index :match_players, :match_lineup_id

    remove_column :match_lineups, :user_id
  end

  def down
    add_column :match_lineups, :user_id, :integer
    drop_table :match_players
  end
end
