class ReceivesInboundEmail
  attr_reader :from, :from_name, :to, :subject, :text_body, :html_body, :tag, :attachments

  def self.receive(message)
    message = Postmark::Json.decode(message)
    message = Postmark::Inbound.to_ruby_hash(message)
    self.new(message)
  end

  def initialize(message)
    @from        = message[:from_full][:email]
    @from_name   = message[:from_full][:name].present? ? message[:from_full][:name] : @from
    @to          = message[:to_full].first[:email]
    @subject     = message[:subject]
    @text_body   = message[:text_body]
    @html_body   = message[:html_body]
    @tag         = message[:tag]
    @attachments = message[:attachments]
  end

  def valid?
    return false if tag == TeamMailer::Tag
    return true if from == ActionMailer::Base.default[:from]
    user && team && user_on_team?
  end

  def team
    @team ||= Team.find_by(email: team_email)
  end

  def serialize
    {
      team_id:     team.id,
      from:        from,
      from_name:   from_name,
      to:          to,
      subject:     subject,
      text_body:   text_body,
      html_body:   html_body,
      attachments: attachments
    }
  end

  private

  def user
    User.find_by(email: from)
  end

  def team_email
    to.partition("@").first
  end

  def user_on_team?
    team.users.include?(user)
  end
end

