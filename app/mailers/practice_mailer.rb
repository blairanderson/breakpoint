class PracticeMailer < ActionMailer::Base
  include MailerHelper

  layout 'mailer'
  helper MailerHelper

  def practice_scheduled(practice, to, options)
    @team_name = practice.team.name
    @mail_type = "Practice"
    @practice  = practice
    @user_id   = options[:user_id]
    @comments  = options[:comments]
    @from      = options.fetch(:from)
    @preview   = options.fetch(:preview, false)
    mail :to    => to,
      :from     => formatted_from(@from),
      :reply_to => options.fetch(:reply_to),
      :subject  => "[#{@practice.team.name}] Practice on #{l @practice.date, :format => :long}"
  end

  def practice_updated(practice, to, options)
    @team_name      = practice.team.name
    @mail_type      = "Practice"
    @practice       = practice
    @user_id        = options[:user_id]
    @comments       = options[:comments]
    @from           = options.fetch(:from)
    @recent_changes = options.fetch(:recent_changes)
    @preview        = options.fetch(:preview, false)
    mail :to    => to,
      :from     => formatted_from(@from),
      :reply_to => options.fetch(:reply_to),
      :subject  => "[#{@practice.team.name}] Update for practice on #{l @practice.date, :format => :long}"
  end
end

