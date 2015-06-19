class ResponsesController < ApplicationController
  layout 'team'
  skip_before_action :authenticate_user!, :only => [:set_availability]
  before_action :only => [:set_availability] do
    set_current_tenant(Team.find(params[:team_id]))
  end
  before_action :load_respondable, only: [:save_availability, :save_note, :update]

  def index
  end

  def set_availability
    @response = Response.response_from_token(params[:token])
    @response.state = params[:available]
    @response.team = current_team if @response.new_record?
    @response.save

    sign_in :user, @response.user
    response = @response.state
    date = l(@response.respondable.date, :format => :long)
    message = "Your #{response} response has been recorded. Add additional availability notes for your captain below."
    redirect_to polymorphic_url([current_team, @response.respondable]), notice: message
  rescue Response::ResponseTokenExpired
    session['user_return_to'] = team_matches_url(current_team)
    redirect_to new_user_session_url, :alert => "The link you tried has expired. Please sign in to set your availability."
  end

  def save_availability
    @response = @respondable.responses.where(id: params[:id]).first
    authorize @response

    @response.state = params[:state]
    @response.save

    respond_to do |format|
      format.js { render nothing: true }
    end
  end

  def save_note
    @response = @respondable.responses.where(id: params[:id]).first
    authorize @response

    if @response.update_attributes(note: params[:note])
      render json: { note: @response.note }
    else
      render json: { errors: @response.errors.full_messages.to_sentence }, status: 422
    end
  end

  def create
    @practice = Practice.find(params[:practice_id])
    @response = @practice.responses.build(permitted_params.responses)
    @response.team = current_team
    @response.user = current_user
    @response.save

    redirect_to team_practices_url(@practice.team)
  end

  def update
    @response = @respondable.responses.where(id: params[:id]).first

    if @response.update_attributes(permitted_params.responses)
      redirect_to team_practices_url(current_team)
    else
      flash[:error] = 'Availability was not updated. Try again or contact support'
      redirect_to team_practices_url(current_team)
    end
  end

  private

  def load_respondable
    klass = [Practice, Match].detect { |c| params["#{c.name.underscore}_id"] }
    @respondable = klass.find(params["#{klass.name.underscore}_id"])
  end
end

