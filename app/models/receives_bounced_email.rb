class ReceivesBouncedEmail
  attr_reader :bounce

  def self.receive(bounce)
    bounce = Postmark::Json.decode(bounce)
    bounce = Postmark::Bounce.new(bounce)
    self.new(bounce)
  end

  def initialize(bounce)
    @bounce = bounce
  end

  def notify
    if valid?
      client = Postmark::ApiClient.new(Rails.application.secrets.simple_postmark_api_key, secure: true)

      captain_emails.each do |email|
        client.deliver(from:      "#{ActionMailer::Base.default[:from]}",
                       to:        email,
                       subject:   "Email delivery problem from BreakpointApp",
                       text_body: "An error occurred when sending email with subject \"#{bounce.subject}\" to #{bounce.email}. " \
                                  "The error type was #{bounce.type} and the details of error was #{bounce.details}. " \
                                  "Please contact admin@breakpointapp.com if you continue have issues")
      end
    end
  end

  def valid?
    user.present?
  end

  private

  def user
    User.find_by(email: bounce.email)
  end

  def captains
    user.teams.flat_map do |team|
      team.team_members.select { |tm| tm.captain? }
    end
  end

  def captain_emails
    User.where(id: captains.collect(&:user_id)).pluck(:email)
  end
end

