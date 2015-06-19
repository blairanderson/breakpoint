require 'spec_helper'

describe MatchLineup do
  it 'stores results in match_sets' do
    user = create(:user)
    team = create(:team)
    team.team_members.create(:user => user)
    ActsAsTenant.current_tenant = team
    match = create(:match)

    match.match_lineups.each do |lineup|
      lineup.match_sets[0].update_attributes(:games_won => 6, :games_lost => 2)
      lineup.match_sets[1].update_attributes(:games_won => 6, :games_lost => 4)
      lineup.games_won.should == 12
      lineup.games_lost.should == 6
      lineup.won?.should == true
    end
    ActsAsTenant.current_tenant = nil
  end
end

