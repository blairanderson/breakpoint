# TODO This should be deleted 7 days after deploy. It is no longer used except if people click links in email after the deploy
class PracticeSessionsController < ApplicationController
  skip_before_action :authenticate_user!, :only => [:set_availability]
  before_action :only => [:set_availability] do
    set_current_tenant(Team.find(params[:team_id]))
  end

  def set_availability
    @practice_session = Practice.practice_session_from_token(params[:token])
    @practice_session.state = params[:available]
    @practice_session.team = current_team if @practice_session.new_record?
    @practice_session.save

    sign_in :user, @practice_session.user
    response = @practice_session.available? ? "yes" : "no"
    date = l(@practice_session.respondable.date, :format => :long)
    message = "Your #{response} response has been recorded."
    redirect_to team_practice_url(current_team, @practice_session.respondable), notice: message
  rescue Response::ResponseTokenExpired
    session['user_return_to'] = team_practices_url(current_team)
    redirect_to new_user_session_url, :alert => "The link you tried has expired. Please sign in to set your availability."
  end
end

