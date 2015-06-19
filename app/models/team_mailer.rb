class TeamMailer
  Tag = "sent-to-team"

  attr_reader :team, :email

  def self.deliver(email)
    new(email).deliver
  end

  def initialize(email)
    @team  = Team.find(email[:team_id])
    @email = email
  end

  def deliver
    client = Postmark::ApiClient.new(Rails.application.secrets.simple_postmark_api_key, secure: true)
    team_emails.in_groups_of(15, false).each do |group|
      client.deliver(message(group))
    end
  end

  private

  def team_emails
    remove_sender(team.team_emails)
  end

  def remove_sender(emails)
    emails.reject { |e| email[:from] == e }
  end

  def message(bcc)
    {
      from:        "#{email[:from_name]} <#{ActionMailer::Base.default[:from]}>",
      reply_to:    email[:to],
      to:          email[:to],
      bcc:         bcc,
      subject:     email[:subject],
      text_body:   email[:text_body],
      html_body:   CGI::unescapeHTML(email[:html_body]),
      tag:         Tag,
      attachments: email[:attachments]
    }
  end
end

