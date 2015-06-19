class RemoveNullConstraints < ActiveRecord::Migration
  def up
    change_column_null :match_sets, :games_won, true
    change_column_null :match_sets, :games_lost, true
  end

  def down
    change_column_null :match_sets, :games_won, false
    change_column_null :match_sets, :games_lost, false
  end
end
