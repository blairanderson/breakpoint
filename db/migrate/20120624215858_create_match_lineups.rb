class CreateMatchLineups < ActiveRecord::Migration
  def change
    create_table :match_lineups do |t|
      t.string     :match_type, :null => false, :default => ''
      t.integer    :ordinal,    :null => false
      t.references :user
      t.references :match

      t.timestamps
    end
    add_index :match_lineups, :user_id
    add_index :match_lineups, :match_id
  end
end
