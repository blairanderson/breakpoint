require 'spec_helper'

describe TeamMailer do
  it 'sends email to all team members, but not to the sender' do
    user  = create(:user)
    user2 = create(:user2)
    user3 = create(:captain)
    team = create(:team)
    team.team_members.create(:user => user)
    team.team_members.create(:user => user2)
    team.team_members.create(:user => user3, :role => 'captain')

    email = {
      team_id:     team.id,
      from:        user.email,
      from_name:   "Dave",
      to:          team.email_address,
      subject:     "test",
      text_body:   "test",
      html_body:   "&lt;p&gt;test&lt;/p&gt;",
      attachments: [{name: "myimage.png", content: "[BASE64-ENCODED CONTENT]", content_type: "image/png"}]
    }
    mailer = TeamMailer.new(email)
    message = {
      from:        "Dave <#{ActionMailer::Base.default[:from]}>",
      reply_to:    team.email_address,
      to:          team.email_address,
      bcc:         [user3.email, user2.email],
      subject:     "test",
      text_body:   "test",
      html_body:   "<p>test</p>",
      tag:         "sent-to-team",
      attachments: [{name: "myimage.png", content: "[BASE64-ENCODED CONTENT]", content_type: "image/png"}]
    }

    sent = mailer.send(:message, mailer.send(:team_emails))
    sent[:from].should eq "Dave <notifications@breakpointapp.com>"
    sent[:to].should eq "team-email@mail.breakpointapp.com"
    sent[:bcc].should =~ ["dave.kroondyk@example.com", "captain@example.com"]
  end
end

