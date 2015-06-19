class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string   :name,            :null => false, :default => ''
      t.datetime :date,            :null => false
      t.integer  :singles_matches, :null => false
      t.integer  :doubles_matches, :null => false

      t.timestamps
    end
  end
end
