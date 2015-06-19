require 'spec_helper'

describe User do
  it 'returns name when first and last exist' do
    user = build(:user, :first_name => 'DK', :last_name => 'Row')
    user.name.should eq 'DK Row'
  end

  it 'returns first name when last is empty' do
    user = build(:user, :first_name => 'DK', :last_name => '')
    user.name.should eq 'DK'
  end

  it 'returns last name when first is empty' do
    user = build(:user, :first_name => '', :last_name => 'Row')
    user.name.should eq 'Row'
  end

  it 'returns email when first and last are empty' do
    user = build(:user, :first_name => '', :last_name => '')
    user.name.should eq 'john.doe@example.com'
  end

  it 'nils work too' do
    user = build(:user, :first_name => 'dkrow', :last_name => nil, :email => 'dkrow@example.com')
    user.name.should eq 'dkrow'
  end

  it 'sets first and last name from name' do
    user = build(:user, :name => 'dk.row')
    user.first_name.should eq 'Dk'
    user.last_name.should eq 'Row'
  end

  it 'parses name from and strips digits' do
    user = build(:user, :name => '123dave_karo123')
    user.first_name.should eq 'Dave'
    user.last_name.should eq 'Karo'
  end

  it 'parses name from with multiple separators' do
    user = build(:user, :name => 'dave_karo_the_great')
    user.first_name.should eq 'Dave'
    user.last_name.should eq 'Karo The Great'
  end

  it 'resets password token' do
    user = create(:user)
    token = user.reset_password_token!
    user.reset_password_token.should_not be_nil
    user.reset_password_token.should eq Devise.token_generator.digest(User.class, :reset_password_token, token)
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

