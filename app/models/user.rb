class User < ActiveRecord::Base
  include DestroyedAt

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
    :async,
    :registerable,
    :recoverable,
    :rememberable,
    :trackable

  has_many :team_members
  has_many :teams,                :through   => :team_members
  has_many :practices,            :through   => :practice_sessions
  has_many :matches,              :through   => :match_availabilities
  has_many :responses,            :dependent => :destroy
  has_many :match_players,        :dependent => :nullify

  validates_presence_of   :email
  validates_uniqueness_of :email, conditions: -> { where(destroyed_at: nil) }, allow_blank: true, if: :email_changed?
  validates_format_of     :email, with: Devise.email_regexp, allow_blank: true, if: :email_changed?

  validates_presence_of     :password, if: :password_required?
  validates_confirmation_of :password, if: :password_required?
  validates_length_of       :password, within: Devise.password_length, allow_blank: true

  def name
    if first_name.present? && last_name.present?
      "#{first_name} #{last_name}"
    elsif first_name.blank? && last_name.present?
      "#{last_name}"
    elsif first_name.present? && last_name.blank?
      "#{first_name}"
    else
      "#{email}"
    end
  end

  def name=(value)
    email_name = value.scan(/[a-zA-Z]+/).map(&:capitalize).join(' ')
    write_attribute(:first_name, email_name.split(' ').first)
    write_attribute(:last_name, email_name.split(' ')[1..-1].try(:join, ' '))
  end

  def never_signed_in?
    sign_in_count == 0
  end

  # copied from https://github.com/plataformatec/devise/blob/354e5022bf2aa482aba7c13bddeb12535b9858ad/lib/devise/models/recoverable.rb#L47-L56
  # because no way to reset the reset_password_token without sending email since
  # they are stored in the DB encrypted
  def reset_password_token!
    raw, enc = Devise.token_generator.generate(self.class, :reset_password_token)
    self.reset_password_token   = enc
    self.reset_password_sent_at = Time.now.utc
    save(validate: false)
    raw
  end

  def captain?
    team_members.where(%Q["team_members"."role" = 'captain' OR "team_members"."role" = 'co-captain']).present?
  end

  protected

  # Checks whether a password is needed or not. For validations only.
  # Passwords are always required if it's a new record, or if the password
  # or confirmation are being set somewhere.
  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end
end

# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  first_name             :string(255)      default("")
#  last_name              :string(255)      default("")
#  phone_number           :string(255)
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default("")
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  time_zone              :string(255)      default("Eastern Time (US & Canada)")
#

