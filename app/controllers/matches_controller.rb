class MatchesController < ApplicationController
  layout 'team'

  def index
    @matches = current_team.matches
  end

  def show
    @match = Match.find(params[:id])
  end

  def new
    @match = current_team.matches.build
    @match.date = Time.zone.now.change(hour: 14, min: 30)
  end

  def edit
    @match = Match.find(params[:id])
    authorize current_team
  end

  def availability_email
    @match = Match.find(params[:id])
    authorize current_team, :update?

    if @match.created? || @match.notified_team?
      @match_email = MatchMailer.match_scheduled(@match,
                                                 current_user.email,
                                                 from:     current_user.name,
                                                 reply_to: current_user.email,
                                                 preview:  true)
    else
      @match_email = MatchMailer.match_updated(@match,
                                               current_user.email,
                                               from:           current_user.name,
                                               reply_to:       current_user.email,
                                               recent_changes: @match.recent_changes,
                                               preview:        true)
    end
  end

  def availabilities
    @match = Match.find(params[:id])
  end

  def player_request_email
    @match = Match.find(params[:id])
    authorize current_team, :update?

    @users = current_team.users.where(id: params[:user_ids].split(",").map(&:to_i))
    @player_request_email = MatchMailer.match_player_request(@match,
                                                             current_user.email,
                                                             from:     current_user.name,
                                                             reply_to: current_user.email,
                                                             preview:  true)
  end

  def lineup_email
    @match = Match.find(params[:id])
    authorize current_team, :update?

    if @match.lineup_created? || @match.notified_team_lineup?
      @match_lineup_email = MatchMailer.match_lineup_set(@match,
                                                         current_user.email,
                                                         from:     current_user.name,
                                                         reply_to: current_user.email)
    else
      @match_lineup_email = MatchMailer.match_lineup_updated(@match,
                                                             current_user.email,
                                                             from:           current_user.name,
                                                             reply_to:       current_user.email)
    end
  end

  def notify
    @match = Match.find(params[:id])
    authorize current_team, :update?

    if @match.created? || @match.notified_team?
      Match.delay.notify(:scheduled,
                         from:     current_user.name,
                         reply_to: current_user.email,
                         comments: params[:comments],
                         match_id: @match.id)
    else
      Match.delay.notify(:updated,
                         from:           current_user.name,
                         reply_to:       current_user.email,
                         comments:       params[:comments],
                         match_id:       @match.id,
                         recent_changes: @match.recent_changes)
    end

    @match.notified!
    redirect_to team_matches_url(@match.team), :notice => 'Availability request email sent to team'
  end

  def notify_player_request
    @match = Match.find(params[:id])
    authorize current_team, :update?

    @users = current_team.users.where(id: params[:user_ids].map(&:to_i))
    Match.delay.notify(:player_request,
                       from:     current_user.name,
                       reply_to: current_user.email,
                       comments: params[:comments],
                       match_id: @match.id,
                       user_ids: @users.pluck(:id))

    redirect_to team_matches_url(@match.team), :notice => 'Player request email sent'
  end

  def notify_lineup
    @match = Match.find(params[:id])
    authorize current_team, :update?

    if @match.lineup_created? || @match.notified_team_lineup?
      Match.delay.notify(:lineup_set,
                         from:     current_user.name,
                         reply_to: current_user.email,
                         comments: params[:comments],
                         match_id: @match.id)
    else
      Match.delay.notify(:lineup_updated,
                         from:           current_user.name,
                         reply_to:       current_user.email,
                         comments:       params[:comments],
                         match_id:       @match.id)
    end

    @match.notified_lineup!
    redirect_to team_matches_url(@match.team), :notice => 'Lineup email sent to team'
  end

  def import
    authorize current_team
  end

  def perform_import
    authorize current_team, :import?

    scraper = UstaScraper.new(params[:team_number], params[:year])
    importer = UstaImporter.new(current_team.id, scraper.matches)
    importer.import

    redirect_to team_matches_url(current_team), :notice => 'Matches imported from USTA'
  rescue => e
    Rollbar.report_exception(e, rollbar_request_data, rollbar_person_data)
    redirect_to team_matches_url(current_team), flash: { error: "Sorry, an error occurred during import. We have been notified and will let you know once it's fixed" }
  end

  def create
    @match = current_team.matches.build(permitted_params.match)
    authorize current_team

    if @match.save
      redirect_to team_matches_url(current_team), :notice => 'Match created'
    else
      render :new
    end
  end

  def update
    @match = Match.find(params[:id])
    authorize current_team

    if @match.update_attributes(permitted_params.match)
      if @match.previous_changes.present?
        if @match.notified_team? || @match.updated?
          flash[:notice] = "Match updated. Send updated email now, or go #{view_context.link_to("back to matches", team_matches_url(@match.team), :class => "alert-link")}"
          next_url = availability_email_team_match_url(current_team, @match)
        end

        @match.reset_notified!
      elsif @match.lineup_changed?
        if @match.notified_team_lineup? || @match.lineup_updated?
          flash[:notice] = "Lineup updated. Send updated email now, or go #{view_context.link_to("back to matches", team_matches_url(@match.team), :class => "alert-link")}"
          next_url = lineup_email_team_match_url(current_team, @match)
        end

        @match.reset_notified_lineup!
      end

      if next_url.present?
        redirect_to next_url
      else
        redirect_to team_matches_url(@match.team), :notice => 'Match updated'
      end
    else
      render :edit
    end
  end

  def destroy
    @match = Match.find(params[:id])
    authorize current_team
    @match.destroy

    redirect_to team_matches_url(@match.team), :notice => 'Match deleted'
  end
end

