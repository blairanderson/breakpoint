namespace :breakpointapp do
  task :update_availabilities_1 => :environment do
    Team.all.each do |team|
      ActsAsTenant.with_tenant(team) do
        team.matches.each do |match|
          team.team_members.each do |team_member|
            availability = match.match_availability_for(team_member.user_id)
            if availability.new_record?
              availability.save
            end
          end
        end
      end
    end
  end
end

