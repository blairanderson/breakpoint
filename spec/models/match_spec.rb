require 'spec_helper'

describe Match do
  before :each do
    @team = create(:team, :singles_matches => 1, :doubles_matches => 1)
    ActsAsTenant.current_tenant = @team
  end

  after :each do
    ActsAsTenant.current_tenant = nil
  end

  it 'accepts a string for date' do
    match = create(:match, :date_string => '6/13/2014', :time_string => '05:30 PM')
    match.date.should eq(Time.zone.parse('2014-06-13 17:30'))
  end

  it 'creates a blank match lineup based off team settings' do
    match = create(:match)

    match.match_lineups.count.should eq(2)
    match.match_lineups[0].match_type.should eq('#1 Singles')
    match.match_lineups[1].match_type.should eq('#1 Doubles')
  end

  it 'creates a blank match player based off match_lineups' do
    match = create(:match)

    match.match_lineups.first.match_players.count.should eq(1)
    match.match_lineups.last.match_players.count.should eq(2)
  end

  it 'creates 3 blank sets for each match_lineup' do
    match = create(:match)

    match.match_lineups.each do |lineup|
      lineup.match_sets.count.should == 3
    end
  end

  it 'determines victory' do
    match = create(:match)

    match.match_lineups.each do |lineup|
      lineup.match_sets[0].update_attributes(:games_won => 6, :games_lost => 2)
      lineup.match_sets[1].update_attributes(:games_won => 6, :games_lost => 4)
    end

    match.matches_won.should == 2
    match.won?.should == true
  end

  it 'returns the match availability for a specified user id' do
    user = create(:user)
    @team.team_members.create(:user => user)
    match = create(:match)
    response = match.responses.first

    match.response_for(user.id).should eq response
  end
end

# == Schema Information
#
# Table name: matches
#
#  id             :integer          not null, primary key
#  date           :datetime         not null
#  location       :text             default(""), not null
#  team_id        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  notified_state :string(255)
#  home_team      :boolean          default(TRUE)
#  comment        :text
#

