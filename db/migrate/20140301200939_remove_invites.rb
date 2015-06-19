class RemoveInvites < ActiveRecord::Migration
  def up
    drop_table :invites
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
