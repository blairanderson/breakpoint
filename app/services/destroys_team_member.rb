class DestroysTeamMember
  attr_reader :team_member

  def initialize(team_member)
    @team_member = team_member
  end

  def destroy
    TeamMember.transaction do
      Response.where(user_id: team_member.user_id).each(&:destroy)
      MatchPlayer.where(user_id: team_member.user_id).each do |player|
        player.update_attributes(user_id: nil)
      end
      team_member.destroy
    end
  end
end

