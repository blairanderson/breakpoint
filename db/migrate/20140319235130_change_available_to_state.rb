class ChangeAvailableToState < ActiveRecord::Migration
  def up
    add_column :match_availabilities, :state, :string, default: 'no_response'
    add_index :match_availabilities, :state
    ActiveRecord::Base.connection.execute "UPDATE match_availabilities SET state = CASE WHEN available = 't' THEN 'yes' ELSE 'no' END"
    remove_column :match_availabilities, :available
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
