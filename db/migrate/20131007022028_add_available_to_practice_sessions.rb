class AddAvailableToPracticeSessions < ActiveRecord::Migration
  def up
    add_column :practice_sessions, :available, :boolean
    execute 'UPDATE practice_sessions SET available = true'
  end

  def down
    remove_column :practice_sessions, :available
  end
end
