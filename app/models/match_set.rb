class MatchSet < ActiveRecord::Base
  include DestroyedAt

  belongs_to :match_lineup

  validates :ordinal,      presence: true
  validates :match_lineup, presence: true
  validates :team,         presence: true


  acts_as_tenant :team
end

