class TeamMemberPolicy < ApplicationPolicy
  def send_welcome_email?
    captain?
  end

  def create?
    captain?
  end

  def update?
    owner? || captain?
  end

  def destroy?
    update?
  end

  def owner?
    user.id == record.user_id
  end

  def captain?
    member = user.team_members.where(:team_id => record.team_id).first
    return false if member.nil?
    member.captain?
  end
end

