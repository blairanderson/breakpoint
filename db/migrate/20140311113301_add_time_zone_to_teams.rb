class AddTimeZoneToTeams < ActiveRecord::Migration
  def up 
    add_column :teams, :time_zone, :string, :default => 'Eastern Time (US & Canada)'
    remove_column :users, :time_zone
  end
  
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
