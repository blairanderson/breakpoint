# TODO This should be deleted 7 days after deploy. It is no longer used except if people click links in email after the deploy
class MatchAvailabilitiesController < ApplicationController
  skip_before_action :authenticate_user!, :only => [:set_availability]
  before_action :only => [:set_availability] do
    set_current_tenant(Team.find(params[:team_id]))
  end

  def set_availability
    @match_availability = Match.match_availability_from_token(params[:token])
    @match_availability.state = params[:available]
    @match_availability.team = current_team if @match_availability.new_record?
    @match_availability.save

    sign_in :user, @match_availability.user
    response = @match_availability.state
    date = l(@match_availability.respondable.date, :format => :long)
    message = "Your #{response} response has been recorded. Add additional availability notes for your captain below."
    redirect_to team_match_url(current_team, @match_availability.respondable), notice: message
  rescue Response::ResponseTokenExpired
    session['user_return_to'] = team_matches_url(current_team)
    redirect_to new_user_session_url, :alert => "The link you tried has expired. Please sign in to set your availability."
  end
end

