class TryItController < ApplicationController
  skip_before_action :authenticate_user!

  def auto_sign_in
    if params[:user] == 'captain'
      sign_in :user, TryItSeeds.new.captain
    elsif params[:user] == 'member'
      sign_in :user, TryItSeeds.new.member
    end

    redirect_to teams_url
  end
end

