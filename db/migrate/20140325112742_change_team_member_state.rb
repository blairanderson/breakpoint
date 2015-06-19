class ChangeTeamMemberState < ActiveRecord::Migration
  def up
    add_column :team_members, :welcome_email_sent_at, :datetime
    ActiveRecord::Base.connection.execute "UPDATE team_members SET welcome_email_sent_at = created_at WHERE state = 'active' OR state = 'new'"
    ActiveRecord::Base.connection.execute "UPDATE team_members SET destroyed_at = '#{Time.now.utc}' WHERE state = 'inactive'"
    remove_column :team_members, :state
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
