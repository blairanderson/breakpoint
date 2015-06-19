class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.references :team, :null => false, :default => ''
      t.references :user,   :null => false, :default => ''

      t.timestamps
    end
    add_index :players, :team_id
    add_index :players, :user_id
  end
end
