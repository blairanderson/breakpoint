require 'spec_helper'

describe 'practices' do
  before :each do
    login_captain
    team = create(:team)
    ActsAsTenant.current_tenant = team
    team.team_members.create(:user => @captain, :role => 'captain')
    team.team_members.create(:user => create(:user2), :role => 'member')
    @practice = create(:practice)
    ActsAsTenant.current_tenant = nil
    visit team_practices_path(@practice.team)
  end

  it 'displays the practices' do
    page.should have_content 'Mon Jun 23, 2014 11:00am'
  end

  it 'shows edit practice only to captains' do
    page.should have_content 'Edit'
    page.should_not have_content 'Delete practice'
    @captain.team_members.where(:team => @practice.team).first.update_attributes(:role => 'member')
    visit team_practices_path(@practice.team)
    page.should_not have_button 'Edit'
  end

  it 'creates a practice' do
    click_link 'Add a practice'
    fill_in 'What day?',  :with => '6/24/2014'
    fill_in 'What time?', :with => '07:00 PM'
    fill_in 'Location',   :with => 'Paxton'
    fill_in 'Comment',    :with => 'tonsofdetail'
    click_button 'Save practice'

    last_email.should be_nil
    page.should have_selector '.alert.alert-success', :text => 'Practice created'
    page.should have_content 'Tue Jun 24, 2014 7:00pm'
    page.should have_content 'Paxton'
  end

  it 'shows errors for invalid practices' do
    click_link 'Add a practice'
    fill_in 'What day?', :with => ''
    click_button 'Save practice'

    page.should have_selector '.alert.alert-danger'
    page.should have_content "Date string can't be blank"
  end

  it 'edits a practice' do
    click_link 'Edit practice'
    fill_in 'What day?', :with => '6/25/2014'
    fill_in 'What time?', :with => '06:00 PM'
    click_button 'Save practice'

    last_email.should be_nil
    page.should have_selector '.alert.alert-success', :text => 'Practice updated'
    page.should have_content 'Wed Jun 25, 2014 6:00pm'
  end

  it 'deletes a practice' do
    click_link 'Edit practice'
    click_link 'Delete practice'

    page.should have_selector '.alert.alert-success', :text => 'Practice deleted'
    page.should_not have_content 'Tue Jun 24, 2014 7:00pm'
  end

  it 'notifies team members', :versioning => true do
    click_link 'Preview and send availability email'
    fill_in 'comments', :with => 'testing extra comments'
    click_button 'Email team'
    page.should have_selector '.alert.alert-success', :text => 'Availability request email sent to team'
    last_email.encoded.should match /testing extra comments/
    last_email.subject.should == "[2012 Summer] Practice on #{I18n.l @practice.date, :format => :long}"
    click_link 'Preview and send availability email'
    page.should have_selector '.text-warning'

    # stays disabled if nothing in the practice changed
    visit team_practices_path(@practice.team)
    click_link 'Edit practice'
    # there is some weird thing going on here with capybara and the \n in text areas
    # https://github.com/jnicklas/capybara/issues/677 says it was fixed, but I'm getting
    # a \n stored at the beginning of the comment field, which the "browser" should ignore.
    # If I manually fill in the comment field with the same value from factory_girl,
    # it works fine.
    fill_in 'Location', :with => @practice.location
    fill_in 'Comment', :with => @practice.comment
    click_button 'Save practice'
    click_link 'Preview and send availability email'
    page.should have_selector '.text-warning'

    # sends updated email after practice is updated
    visit team_practices_path(@practice.team)
    click_link 'Edit practice'
    fill_in 'What day?', :with => '6/25/2014'
    fill_in 'What time?', :with => '06:00 PM'
    click_button 'Save practice'
    page.should have_content 'custom for each player'
    click_link 'back to practices'
    click_link 'Preview and send availability email'
    page.should_not have_content 'The practice has not changed'
    click_button 'Email team'
    @practice.reload
    last_email.encoded.should_not match /testing extra comments/
    last_email.subject.should == "[2012 Summer] Update for practice on #{I18n.l @practice.date, :format => :long}"
    click_link 'Preview and send availability email'
    page.should have_selector '.text-warning'
  end
end

