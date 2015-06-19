namespace :breakpointapp do
  task :fix_destroyed_team_members_2 => :environment do
    TeamMember.destroyed("2014-03-27 01:10:06").each do |team_member|
      ActsAsTenant.with_tenant(team_member.team) do
        PracticeSession.where(user_id: team_member.user_id).each(&:destroy)
        MatchAvailability.where(user_id: team_member.user_id).each(&:destroy)
        MatchPlayer.where(user_id: team_member.user_id).each do |player|
          player.update_attributes(user_id: nil)
        end
      end
    end
  end
end

