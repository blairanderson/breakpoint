class AddNoteToMatchAvailabilities < ActiveRecord::Migration
  def change
    add_column :match_availabilities, :note, :text
  end
end
