class AddAvailableToMatchAvailabilities < ActiveRecord::Migration
  def up
    add_column :match_availabilities, :available, :boolean
    execute 'UPDATE match_availabilities SET available = true'
  end

  def down
    remove_column :match_availabilities, :available
  end
end

