class AddUstaMatchIdToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :usta_match_id, :string
  end
end
