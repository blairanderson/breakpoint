class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.datetime   :date,     :null => false
      t.string     :location, :null => false, :default => ''
      t.string     :opponent, :null => false, :default => ''
      t.references :team

      t.timestamps
    end
    add_index :matches, :team_id
  end
end
