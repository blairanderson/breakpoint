class Team < ActiveRecord::Base
  include DestroyedAt
  include DateParser

  has_many :practices,    -> { order(:date => :asc) }, :dependent => :destroy
  has_many :matches,      -> { order(:date => :asc) }, :dependent => :destroy
  has_many :team_members, :dependent => :destroy
  has_many :users,                :through => :team_members, :source => :user

  validates :name,            presence: true, uniqueness: true
  validates :email,
    uniqueness: { allow_blank: true },
    format:     { with: /\A[a-z0-9\-_]+\z/, message: "can only contain lowercase letters, numbers, - and _", allow_blank: true }
  validates :singles_matches, presence: true
  validates :doubles_matches, presence: true
  validates :time_zone,       inclusion: { in: ActiveSupport::TimeZone.all.map(&:name) }

  def self.newest
    order('date desc')
  end

  def email_address
    "#{email}@mail.breakpointapp.com"
  end

  def upcoming_practices
    practices.where('date > ?', Time.zone.now).order('date asc')
  end

  def previous_practices
    practices.where('date < ?', Time.zone.now).order('date asc')
  end

  def upcoming_matches
    matches.where('date > ?', Time.zone.now).order('date asc')
  end

  def previous_matches
    matches.where('date < ?', Time.zone.now).order('date asc')
  end

  def team_emails
    users.pluck(:email)
  end

  def captains
    users.where("team_members.role = 'captain' OR team_members.role = 'co-captain'")
  end

  def team_member_for(user_id)
    team_members.where(user_id: user_id).first
  end
end

# TODO
# Club/Facility
# Team Name
# Team Type
#  Adult
#  Mixed
#  Senior
#  Senior 65
#  Senior 60
#  Fifty Mixed
#  Combo
#  Juniors
#  HighSchool
#  College
#  Other
# Level
#  2.5
#  3.0
#  3.5
#  4.0
#  4.5
#  5.0
#  5.5
#  6.0
#  6.5
#  7.0
#  7.5
#  8.0
#  8.5
#  9.0
#  9.5
#  Open
#  Juniors
#  HighSchool
#  College
#  Other
# Singles Matches 0-9
# Doubels Matches 0-9
# Alternates 0-9 (???)

# == Schema Information
#
# Table name: teams
#
#  created_at      :datetime         not null
#  date            :datetime         not null
#  doubles_matches :integer          not null
#  id              :integer          not null, primary key
#  name            :string(255)      default(""), not null
#  singles_matches :integer          not null
#  updated_at      :datetime         not null
#

