class ChangeMatchSetsRelationship < ActiveRecord::Migration
  def up
    rename_column :match_sets, :match_id, :match_lineup_id
  end

  def down
    rename_column :match_sets, :match_lineup_id, :match_id
  end
end
