class Admin::UsersController < Admin::AdminController
  def index
    @users = User.includes(:team_members => :team).order("created_at desc")
  end

  def become
    session[:admin_id] = current_user.id
    sign_in :user, User.find(params[:id]), bypass: true
    redirect_to teams_url
  end

  def test_raven
    raise StandardError
  end
end

