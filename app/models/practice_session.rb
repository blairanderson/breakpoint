class PracticeSession < ActiveRecord::Base
  include DestroyedAt

  belongs_to :user
  belongs_to :practice

  validates :team, presence: true

  acts_as_tenant :team
end

# == Schema Information
#
# Table name: practice_sessions
#
#  created_at  :datetime         not null
#  id          :integer          not null, primary key
#  practice_id :integer
#  updated_at  :datetime         not null
#  user_id     :integer
#

