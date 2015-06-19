require "spec_helper"

describe PracticeMailer do
  before :each do
    @user = create(:user)
    @user2 = create(:user2)
    @team = create(:team, :users => [@user, @user2])
    ActsAsTenant.current_tenant = @team
    @practice = create(:practice)
  end

  after :each do
    ActsAsTenant.current_tenant = nil
  end

  let(:created_options) {
    { from: @user.name, reply_to: @user.email, user_id: @user2.id }
  }

  let(:updated_options) {
   { from: @user.name, reply_to: @user.email, user_id: @user2.id, recent_changes: [] }
  }

  it 'renders practice scheduled preview' do
    mail = PracticeMailer.practice_scheduled(@practice, @user2.email, created_options.merge(preview: true))
    mail.body.should match /custom for each player/
  end

  it 'sends practice scheduled email' do
    PracticeMailer.practice_scheduled(@practice, @user2.email, created_options).deliver

    last_email.should_not be_nil
    last_email.to.should =~ ['dave.kroondyk@example.com']
    last_email[:from].formatted.should eq ['John Doe <notifications@breakpointapp.com>']
    last_email.subject.should == "[2012 Summer] Practice on #{I18n.l @practice.date, :format => :long}"
    last_email.encoded.should match /When:/
  end

  it 'renders practice updated preview' do
    mail = PracticeMailer.practice_updated(@practice, @user2.email, updated_options.merge(preview: true))
    mail.body.should match /custom for each player/
  end

  it 'sends practice updated email', :versioning => true do
    PracticeMailer.practice_updated(@practice, @user2.email, updated_options).deliver

    last_email.should_not be_nil
    last_email.to.should =~ ['dave.kroondyk@example.com']
    last_email.subject.should == "[2012 Summer] Update for practice on #{I18n.l @practice.date, :format => :long}"
    last_email.encoded.should match /When:/
  end
end

