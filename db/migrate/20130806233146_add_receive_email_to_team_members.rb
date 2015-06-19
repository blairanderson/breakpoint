class AddReceiveEmailToTeamMembers < ActiveRecord::Migration
  def change
    add_column :team_members, :receive_email, :boolean, :null => false, :default => true
  end
end
