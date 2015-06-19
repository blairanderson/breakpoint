require 'spec_helper'

describe Team do
  it 'validates email' do
    team = create(:team)
    team.update_attributes(email: "no_UPPER_case")
    team.valid?.should be_false

    team.update_attributes(email: "no_@_allowed")
    team.valid?.should be_false

    team.update_attributes(email: "no_!#$%^&*(_allowed")
    team.valid?.should be_false

    team.update_attributes(email: "valid-with-under_score-or-dashes")
    team.valid?.should be_true
  end

  it 'returns upcoming practices' do
    team = create(:team)
    ActsAsTenant.with_tenant(team) do
      practice = create(:practice)
      practice2 = create(:practice_in_past)

      team.practices.count.should eq(2)
      team.upcoming_practices.count.should eq(1)
    end
  end

  it 'returns upcoming matches' do
    team = create(:team)
    ActsAsTenant.with_tenant(team) do
      match = create(:match)
      match2 = create(:match_in_past)

      team.matches.count.should eq(2)
      team.upcoming_matches.count.should eq(1)
    end
  end

  it 'returns users team emails for team members not removed' do
    user = create(:user)
    user2 = create(:user2)
    team = create(:team)
    member = team.team_members.create(:user => user)
    member2 = team.team_members.create(:user => user2)
    ActsAsTenant.with_tenant(team) do
      member.destroy
    end

    team.users.should eq [user2]
    team.team_emails.should eq ['dave.kroondyk@example.com']
  end
end

# == Schema Information
#
# Table name: teams
#
#  created_at      :datetime         not null
#  date            :datetime         not null
#  doubles_matches :integer          not null
#  id              :integer          not null, primary key
#  name            :string(255)      default(""), not null
#  singles_matches :integer          not null
#  updated_at      :datetime         not null
#

