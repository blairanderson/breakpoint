require 'spec_helper'

describe ReceivesInboundEmail do
  it 'parses the json' do
    email = ReceivesInboundEmail.receive(File.read(File.expand_path("../team_email.json", __FILE__)))
    email.from.should       eq "myUser@theirDomain.com"
    email.from_name.should  eq "John Doe"
    email.to.should         eq "451d9b70cf9364d23ff6f9d51d870251569e+ahoy@inbound.postmarkapp.com"
    email.subject.should    eq "This is an inbound message"
    email.text_body.should  eq "[ASCII]"
    email.html_body.should  eq "[HTML(encoded)]"
    email.send(:team_email).should eq "451d9b70cf9364d23ff6f9d51d870251569e+ahoy"
  end

  it 'validates team email' do
    team = create(:team, :singles_matches => 1, :doubles_matches => 1, :email => "winsanity")
    user = create(:user)
    team.team_members.create(user: user, team: team)
    team2 = create(:team, :singles_matches => 1, :doubles_matches => 1, :name => "team2", :email => "winsanity2")
    ActsAsTenant.current_tenant = team2

    email = ReceivesInboundEmail.receive(File.read(File.expand_path("../team_email.json", __FILE__)))
    email.instance_variable_set(:@from, user.email)
    email.instance_variable_set(:@to, "winsanity2@example.com")

    expect(email.valid?).to be_false

    team2.team_members.create(user: user, team: team2)
    expect(email.valid?).to be_true

    ActsAsTenant.current_tenant = nil
  end
end

