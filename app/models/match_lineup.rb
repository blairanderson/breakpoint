class MatchLineup < ActiveRecord::Base
  include DestroyedAt

  belongs_to :match
  has_many   :match_players, :dependent => :destroy
  has_many   :players,       :through => :match_players, :source => :user
  has_many   :match_sets,    -> { order(:ordinal) }, :dependent => :destroy

  validates :team, presence: true

  accepts_nested_attributes_for :match_players
  accepts_nested_attributes_for :match_sets

  acts_as_tenant :team

  def has_results?
    @has_results ||= match_sets.pluck(:games_won, :games_lost).flatten.compact.count > 0
  end

  def won?
    games_won > games_lost
  end

  def games_won
    match_sets.sum(:games_won)
  end

  def games_lost
    match_sets.sum(:games_lost)
  end
end

# == Schema Information
#
# Table name: match_lineups
#
#  created_at :datetime         not null
#  id         :integer          not null, primary key
#  match_id   :integer
#  match_type :string(255)      default(""), not null
#  ordinal    :integer          not null
#  updated_at :datetime         not null
#  user_id    :integer
#

