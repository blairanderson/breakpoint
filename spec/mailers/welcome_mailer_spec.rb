require "spec_helper"

describe WelcomeMailer do
  before :each do
    @user = create(:user)
    @user2 = create(:user2)
    @team = create(:team, :users => [@user, @user2])
  end

  it 'sends new user welcome email' do
    options = {
      from:           @user.name,
      reply_to:       @user.email,
      team_member_id: @user2.team_members.first.id
    }

    WelcomeMailer.new_user_welcome(options).deliver

    last_email.should_not be_nil
    last_email.to.should eq ['dave.kroondyk@example.com']
    last_email[:from].formatted.should eq ['John Doe <notifications@breakpointapp.com>']
    last_email.subject.should eq "[#{@team.name}] #{@user.name} added you to the team"
    last_email.encoded.should match /I created an account for you on Breakpoint App/
  end

  it 'sends welcome email' do
    options = {
      from:           @user.name,
      reply_to:       @user.email,
      team_member_id: @user2.team_members.first.id
    }

    WelcomeMailer.welcome(options).deliver

    last_email.should_not be_nil
    last_email.to.should eq ['dave.kroondyk@example.com']
    last_email.subject.should eq "[#{@team.name}] #{@user.name} added you to the team"
    last_email.encoded.should match /I added you to a team/
  end
end

