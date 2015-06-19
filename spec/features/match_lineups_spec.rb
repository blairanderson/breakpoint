require 'spec_helper'

describe 'match_lineups' do
  before :each do
    login_captain
    @team = create(:team)
    ActsAsTenant.with_tenant(@team) do
      @match = create(:match, team: ActsAsTenant.current_tenant)
      @match.team.team_members.create(:user => @captain, :role => 'captain')
      @match.team.team_members.create(:user => create(:user2), :role => 'member')
    end
    visit team_matches_path(@match.team)
  end

  it 'sets the match lineup', js: true do
    click_link 'Yes'
    click_link   'Set the lineup'
    first("option[value='#{@captain.id}']").select_option
    click_button 'Save match lineup'

    page.should have_selector '.alert.alert-success', :text => 'Match updated'
    ActsAsTenant.with_tenant(@team) do
      @match.match_lineups.first.match_players.where(:user_id => @captain.id).count.should eq(1)
    end

    click_link 'Set the lineup'
    first("option[value='']").select_option
    click_button 'Save match lineup'

    page.should have_selector '.alert.alert-success', :text => 'Match updated'
    ActsAsTenant.with_tenant(@team) do
      @match.match_lineups.first.match_players.where(:user_id => @captain.id).count.should eq(0)
    end
  end

  it 'sets the match lineup', js: true do
    click_link 'Yes'
    click_link   'Set the lineup'
    first("option[value='#{@captain.id}']").select_option
    click_button 'Save match lineup'
    click_link 'Preview and send lineup email'
    fill_in 'comments', :with => 'testing extra comments'
    click_button 'Email team'

    last_email.body.should match /testing extra comments/
    last_email.attachments.should have(1).attachment
    last_email.attachments.first.content_type.should eq 'text/calendar; charset=UTF-8'
    page.should have_selector '.alert.alert-success', :text => 'Lineup email sent to team'
  end
end

