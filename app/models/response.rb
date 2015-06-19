class Response < ActiveRecord::Base
  class ResponseTokenExpired < StandardError; end

  include DestroyedAt
  STATES = %w[no_response yes maybe no]

  belongs_to :user
  belongs_to :respondable, polymorphic: true

  validates :team, presence: true
  validates :note, length: { maximum: 140 }

  acts_as_tenant :team

  delegate :yes?, :maybe?, :no?, :no_response?, :to => :current_state

  def self.response_from_token(token)
    respondable_id, respondable_type, user_id, timestamp = Rails.application.message_verifier("email-response").verify(token)

    if timestamp < 7.days.ago
      raise Response::ResponseTokenExpired
    end

    klass = [Practice, Match].detect { |c| respondable_type == c }
    klass.find(respondable_id).response_for(user_id)
  end

  def self.no_response
    where(state: 'no_response')
  end

  def self.available
    where(state: 'yes')
  end

  def self.maybe_available
    where(state: 'maybe')
  end

  def self.not_available
    where(state: 'no')
  end

  def current_state
    state.inquiry
  end
end

# == Schema Information
#
# Table name: match_availabilities
#
#  created_at :datetime         not null
#  id         :integer          not null, primary key
#  match_id   :integer
#  updated_at :datetime         not null
#  user_id    :integer
#

