class WelcomeMailer < ActionMailer::Base
  include MailerHelper

  layout 'mailer'

  def new_user_welcome(options)
    welcome_email(options)
  end

  def welcome(options)
    welcome_email(options)
  end

  def welcome_email(options)
    @team_member = TeamMember.find(options.fetch(:team_member_id))
    @team_name   = @team_member.team.name
    @mail_type   = "Welcome"
    @token       = @team_member.user.reset_password_token!
    @from        = options.fetch(:from)
    mail :to    => @team_member.user.email,
      :from     => formatted_from(options.fetch(:from)),
      :reply_to => options.fetch(:reply_to),
      :subject  => "[#{@team_name}] #{@from} added you to the team"
  end
end

