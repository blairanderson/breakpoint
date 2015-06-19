require 'spec_helper'

describe 'teams' do
  before :each do
    login_captain
    @team = create(:team)
    ActsAsTenant.current_tenant = @team
    @team.team_members.create(:user => @captain, :role => 'captain')
    ActsAsTenant.current_tenant = nil
    visit teams_path
  end

  it 'displays the teams' do
    page.should have_selector '.page-header', :text => 'Teams'
    page.should have_content '2012 Summer'
  end

  it 'creates a team' do
    click_link 'New team'
    fill_in 'Name',           :with => '2013 Summer'
    fill_in 'Team distribution email address', :with => 'woop-woop'
    fill_in 'Starting when?', :with => 'June 2013'
    select '2',               :from => 'Singles matches'
    select '3',               :from => 'Doubles matches'
    click_button 'Save team'

    page.should have_selector '.alert.alert-success', :text => 'Team created'
    page.should have_content '2013 Summer'
    Team.find_by_name('2013 Summer').users.first.should == @captain
    Team.find_by_name('2013 Summer').team_members.first.role.should == TeamMember::ROLES.first
  end

  it 'shows errors for invalid teams' do
    click_link 'New team'
    click_button 'Save team'

    page.should have_selector '.alert.alert-danger'
    page.should have_content "Name can't be blank"
  end

  it 'edits a team' do
    click_link 'Edit team'
    fill_in 'Name', :with => '2010 Summer'
    click_button 'Save team'

    page.should have_selector '.alert.alert-success', :text => 'Team updated'
    page.should have_content '2010 Summer'
  end

  it 'deletes a team' do
    click_link 'Edit team'
    click_link 'Delete team'

    page.should have_selector '.alert.alert-success', :text => 'Team deleted'
    page.should_not have_content '2012 Summer'
  end
end

