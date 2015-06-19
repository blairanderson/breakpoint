class Match < ActiveRecord::Base
  NOTIFIED_LINEUP_STATES = %w[lineup_created lineup_updated notified_team_lineup]

  include DestroyedAt
  include DateTimeParser
  include NotifyStateMachine
  include Respondable

  has_many :match_lineups, -> { order(:ordinal) }, :dependent => :destroy

  validates :team, presence: true

  accepts_nested_attributes_for :match_lineups

  after_create :setup_match_lineups
  after_create :setup_match_responses

  delegate :lineup_created?, :lineup_updated?, :notified_team_lineup?, :to => :notified_team_lineup_state

  acts_as_tenant :team
  has_paper_trail :ignore => [:notified_state, :notified_lineup_state, :updated_at]

  def self.notify(name, options)
    match = find(options.fetch(:match_id))

    if options[:user_ids]
      send_to = match.team.users.select { |u| options[:user_ids].include?(u.id) }
    else
      send_to = match.team.users
    end

    send_to.each do |to|
      MatchMailer.send("match_#{name}", match, to.email, options.merge(user_id: to.id)).deliver
    end
  end

  # TODO This should be deleted 7 days after deploy. It is no longer used except if people click links in email after the deploy
  def self.match_availability_from_token(token)
    match_id, user_id, timestamp = Rails.application.message_verifier("match-email-response").verify(token)

    if timestamp < 7.days.ago
      raise Response::ResponseTokenExpired
    end

    find(match_id).response_for(user_id)
  end

  def team_location
    home_team? ? 'Home' : 'Away'
  end

  def available_players
    player_status(responses.includes(:user).available)
  end

  def maybe_available_players
    player_status(responses.includes(:user).maybe_available)
  end

  def not_available_players
    player_status(responses.includes(:user).not_available)
  end

  def no_response_players
    player_status(responses.includes(:user).no_response)
  end

  def player_status(responses)
    responses.map do |response|
      if response.note.blank?
        [response.user.name, response.user.id]
      else
        ["#{response.user.name} - #{response.note}", response.user.id]
      end
    end
  end

  def players_status
    @players_status ||= {
      "Yes"         => available_players,
      "Maybe"       => maybe_available_players,
      "No"          => not_available_players,
      "No Response" => no_response_players
    }
  end

  def recent_changes
    versions.last.changeset
  end

  def lineup_changed?
    match_lineups.flat_map(&:match_players).map(&:previous_changes).reject { |change| change.blank? }.present?
  end

  def notified_team_lineup_state
    (notified_lineup_state || NOTIFIED_LINEUP_STATES.first).inquiry
  end

  def reset_notified_lineup!
    update_attributes!(:notified_lineup_state => 'lineup_updated') if notified_team_lineup?
  end

  def notified_lineup!
    update_attributes!(:notified_lineup_state => 'notified_team_lineup') if lineup_created? || lineup_updated?
  end

  def has_results?
    match_lineups.collect { |l| l.has_results? }.any?
  end

  def won?
    matches_won > matches_lost
  end

  def matches_won
    result[true]
  end

  def matches_lost
    result[false]
  end

  private

  def setup_match_lineups
    ordinal = 0
    1.upto(team.singles_matches) do |singles_match|
      lineup = match_lineups.create :match_type => "##{singles_match} Singles", :ordinal => ordinal
      lineup.match_players.create
      1.upto(3) { |i| lineup.match_sets.create(:ordinal => i) }
      ordinal += 1
    end

    1.upto(team.doubles_matches) do |doubles_match|
      lineup = match_lineups.create :match_type => "##{doubles_match} Doubles", :ordinal => ordinal
      2.times { lineup.match_players.create }
      1.upto(3) { |i| lineup.match_sets.create(:ordinal => i) }
      ordinal += 1
    end
  end

  def setup_match_responses
    ActsAsTenant.with_tenant(team) do
      team.team_members.each do |team_member|
        responses.create!(user_id: team_member.user_id)
      end
    end
  end

  def result
    @result ||= match_lineups.collect { |l| l.won? }.inject(Hash.new(0)) { |h,i| h[i] += 1; h }
  end
end

# TODO
# Split Format (enable second time option - for double?)

# == Schema Information
#
# Table name: matches
#
#  id             :integer          not null, primary key
#  date           :datetime         not null
#  location       :text             default(""), not null
#  team_id        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  notified_state :string(255)
#  home_team      :boolean          default(TRUE)
#  comment        :text
#

