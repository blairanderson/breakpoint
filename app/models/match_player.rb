class MatchPlayer < ActiveRecord::Base
  include DestroyedAt

  belongs_to :user
  belongs_to :match_lineup

  validates :team, presence: true

  acts_as_tenant :team
end

