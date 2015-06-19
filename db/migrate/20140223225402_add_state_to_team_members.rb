class Invite < ActiveRecord::Base
end
class AddStateToTeamMembers < ActiveRecord::Migration
  def up
    add_column :team_members, :state, :string, default: "new", null: false
    TeamMember.all.each do |tm|
      invite = Invite.where(user_id: tm.user_id, team_id: tm.team_id).first
      state = tm.read_attribute(:active) ? "active" : "inactive"
      state = "new" if invite.nil? && tm.role == 'member' #captains don't have an invite usually
      tm.update_attributes(state: state)
    end
    remove_column :team_members, :active
    remove_column :team_members, :receive_email
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
