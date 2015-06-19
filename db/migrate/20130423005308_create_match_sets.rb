class CreateMatchSets < ActiveRecord::Migration
  def change
    create_table :match_sets do |t|
      t.integer :games_won, :null => false
      t.integer :games_lost, :null => false
      t.integer :ordinal, :null => false
      t.references :match, :null => false

      t.timestamps
    end
  end
end
