require "spec_helper"

describe MatchMailer do
  before :each do
    @user = create(:user)
    @user2 = create(:user2)
    @team = create(:team)
    @team.team_members.create(:user => @user)
    @team.team_members.create(:user => @user2)
    ActsAsTenant.current_tenant = @team
    @match = create(:match)
    @match.match_lineups.each do |lineup|
      lineup.match_players.first.update_attributes(user_id: @user.id)
    end
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

  it 'renders match scheduled preview' do
    mail = MatchMailer.match_scheduled(@match, @user2.email, created_options.merge(preview: true))
    mail.body.should match /custom for each player/
  end

  it 'sends match scheduled email' do
    MatchMailer.match_scheduled(@match, @user2.email, created_options).deliver

    last_email.to.should eq ['dave.kroondyk@example.com']
    last_email[:from].formatted.should eq ['John Doe <notifications@breakpointapp.com>']
    last_email.subject.should == "[2012 Summer] Match on #{I18n.l @match.date, :format => :long}"
    last_email.encoded.should match /When:/
    last_email.encoded.should_not match /custom for each player/
  end

  it 'renders match updated preview' do
    mail = MatchMailer.match_updated(@match, @user2.email, updated_options.merge(preview: true))
    mail.body.should match /custom for each player/
  end

  it 'sends match updated email', :versioning => true do
    MatchMailer.match_updated(@match, @user2.email, updated_options).deliver

    last_email.to.should =~ ['dave.kroondyk@example.com']
    last_email.subject.should == "[2012 Summer] Update for match on #{I18n.l @match.date, :format => :long}"
    last_email.encoded.should match /When:/
    last_email.encoded.should_not match /custom for each player/
  end

  it 'renders match player request preview' do
    mail = MatchMailer.match_player_request(@match, @user2.email, created_options.merge(preview: true))
    mail.body.should match /custom for each player/
  end

  it 'sends match player request email' do
    MatchMailer.match_player_request(@match, @user2.email, created_options).deliver

    last_email.to.should eq ['dave.kroondyk@example.com']
    last_email[:from].formatted.should eq ['John Doe <notifications@breakpointapp.com>']
    last_email.subject.should == "[2012 Summer] Need players for match on #{I18n.l @match.date, :format => :long}"
    last_email.encoded.should match /When:/
    last_email.encoded.should_not match /custom for each player/
  end

  it 'sends match lineup set email' do
    MatchMailer.match_lineup_set(@match, @user2.email, created_options).deliver

    last_email.to.should eq ['dave.kroondyk@example.com']
    last_email[:from].formatted.should eq ['John Doe <notifications@breakpointapp.com>']
    last_email.subject.should == "[2012 Summer] Lineup for match on #{I18n.l @match.date, :format => :long}"
    last_email.encoded.should match /Lineup/
    last_email.encoded.should match /John Doe/
  end

  it 'sends match lineup updated email', :versioning => true do
    MatchMailer.match_lineup_updated(@match, @user2.email, updated_options).deliver

    last_email.to.should eq ['dave.kroondyk@example.com']
    last_email.subject.should == "[2012 Summer] Lineup updated for match on #{I18n.l @match.date, :format => :long}"
    last_email.encoded.should match /Lineup/
    last_email.encoded.should match /John Doe/
  end
end

