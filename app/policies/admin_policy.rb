class AdminPolicy
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def admin?
    user.admin?
  end
end

