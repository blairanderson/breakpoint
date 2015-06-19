require 'spec_helper'

describe 'match responses' do
  before :each do
    login_captain
    ActsAsTenant.current_tenant = create(:team)
    @match = create(:match, team: ActsAsTenant.current_tenant)
    @match.team.team_members.create(:user => @captain, :role => 'captain')
    ActsAsTenant.current_tenant = nil
    visit team_matches_path(@match.team)
  end

  it 'lists all match responses', js: true do
    click_link 'See who can play when'
    page.should have_selector '.label', :text => 'n/a'

    visit team_matches_path(@match.team)
    click_link "No"
    click_link 'See who can play when'
    page.should have_selector '.label-danger', :text => 'no'
    page.should_not have_selector '.label-success', :text => 'yes'

    visit team_matches_path(@match.team)
    click_link 'Yes'
    click_link 'See who can play when'
    page.should have_selector '.label-success', :text => 'yes'
    page.should_not have_selector '.label-danger', :text => 'no'

    visit team_matches_path(@match.team)
    click_link 'Maybe'
    click_link 'See who can play when'
    page.should have_selector '.label-info', :text => 'maybe'
    page.should_not have_selector '.label-success', :text => 'yes'
  end

  it 'toggles match response', js: true do
    click_link 'Yes'
    page.should have_selector '.btn-success.disabled', :text => 'Yes'

    click_link "Maybe"
    page.should have_selector '.btn-info.disabled', :text => 'Maybe'

    click_link "No"
    page.should have_selector '.btn-danger.disabled', :text => 'No'
  end

  it 'accepts availability from email' do
    click_link 'Sign out'
    visit set_availability_team_responses_url(
      @match.team,
      available: 'yes',
      token: @match.response_token_for(@captain.id))
    page.should have_selector '.alert-success', :text => 'yes response'

    click_link 'Sign out'
    visit set_availability_team_responses_url(
      @match.team,
      available: 'no',
      token: @match.response_token_for(@captain.id))
    page.should have_selector '.alert-success', :text => 'no response'
  end
end

