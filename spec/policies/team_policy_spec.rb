require 'spec_helper'

describe TeamPolicy do
  subject { TeamPolicy }
  before :each do
    @user = create(:user)
    @team = create(:team, :users => [@user])
  end

  permissions :captain? do
    it 'grants access if user is captain' do
      @user.team_members.first.update_attributes(:role => 'captain')
      should permit(@user, @team)
    end

    it 'denies access if user is not captain' do
      @user.team_members.first.update_attributes(:role => 'member')
      should_not permit(@user, @team)
    end
  end
end

