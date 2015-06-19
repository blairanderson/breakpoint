class MatchLineupsController < ApplicationController
  layout 'team'

  def edit
    @match = Match.find(params[:id])
    authorize current_team
  end
end

