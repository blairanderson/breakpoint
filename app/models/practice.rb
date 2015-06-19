class Practice < ActiveRecord::Base
  include DestroyedAt
  include DateTimeParser
  include NotifyStateMachine
  include Respondable

  validates :team, presence: true

  acts_as_tenant :team
  has_paper_trail :ignore => [:notified_state, :updated_at]

  def self.notify(name, options)
    practice = find(options.fetch(:practice_id))

    practice.team.users.each do |to|
      PracticeMailer.send("practice_#{name}", practice, to.email, options.merge(user_id: to.id)).deliver
    end
  end

  # TODO This should be deleted 7 days after deploy. It is no longer used except if people click links in email after the deploy
  def self.practice_session_from_token(token)
    practice_id, user_id, timestamp = Rails.application.message_verifier("practice-email-response").verify(token)

    if timestamp < 7.days.ago
      raise Response::ResponseTokenExpired
    end

    find(practice_id).response_for(user_id)
  end

  def available_players
    responses.includes(:user).available.order(:updated_at).collect(&:user)
  end

  def not_available_players
    responses.includes(:user).not_available.order(:updated_at).collect(&:user)
  end

  def recent_changes
    versions.last.changeset
  end
end

# == Schema Information
#
# Table name: practices
#
#  id             :integer          not null, primary key
#  date           :datetime         not null
#  comment        :text
#  team_id        :integer          default(0), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  notified_state :string(255)
#  location       :text
#

