require 'spec_helper'

describe Practice do
  before :each do
    @team = create(:team, :singles_matches => 1, :doubles_matches => 1)
    ActsAsTenant.current_tenant = @team
  end

  after :each do
    ActsAsTenant.current_tenant = nil
  end

  it 'accepts a string for date' do
    practice = create(:practice, :date_string => '6/13/2014', :time_string => '05:30 PM')
    practice.date.should eq(Time.zone.parse('2014-06-13 17:30'))
  end

  it 'returns the practice session for a specified user id' do
    user = create(:user)
    @team.team_members.create(:user => user)
    practice = create(:practice)
    response = practice.responses.create(state: "yes", user: user)

    practice.response_for(user.id).should eq response
  end
end

# == Schema Information
#
# Table name: practices
#
#  id             :integer          not null, primary key
#  date           :datetime         not null
#  comment        :text
#  team_id        :integer          default(0), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  notified_state :string(255)
#  location       :text
#

