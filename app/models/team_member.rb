class TeamMember < ActiveRecord::Base
  include DestroyedAt

  ROLES = %w[captain co-captain member]

  belongs_to :user
  belongs_to :team

  after_create :setup_responses

  def self.welcome_email_unsent
    where(welcome_email_sent_at: nil)
  end

  def self.welcome_email_sent
    where.not(welcome_email_sent_at: nil)
  end

  def captain?
    role == 'captain' || role == 'co-captain'
  end

  def welcome_email_unsent?
    welcome_email_sent_at.nil?
  end

  def welcome_email_sent?
    !!welcome_email_sent_at
  end

  def send_welcome!(from_user_id)
    from_user = User.find(from_user_id)
    if user.never_signed_in?
      WelcomeMailer.delay.new_user_welcome(from:           from_user.name,
                                           reply_to:       from_user.email,
                                           team_member_id: id)
    else
      WelcomeMailer.delay.welcome(from:           from_user.name,
                                  reply_to:       from_user.email,
                                  team_member_id: id)
    end
    welcome_email_sent!
  end

  def welcome_email_sent!
    update!(welcome_email_sent_at: Time.zone.now)
  end

  def setup_responses
    ActsAsTenant.with_tenant(team) do
      team.matches.each do |match|
        match.responses.create!(user_id: user_id)
      end
    end
  end
end

# == Schema Information
#
# Table name: team_members
#
#  id         :integer          not null, primary key
#  team_id    :integer          default(0), not null
#  user_id    :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

