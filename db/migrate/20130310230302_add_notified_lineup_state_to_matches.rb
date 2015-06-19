class AddNotifiedLineupStateToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :notified_lineup_state, :string
  end
end
