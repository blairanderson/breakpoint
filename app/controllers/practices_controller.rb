class PracticesController < ApplicationController
  layout 'team'

  def index
    @upcoming_practices = current_team.upcoming_practices
    @previous_practices = current_team.previous_practices
  end

  def show
    @practice = Practice.find(params[:id])
  end

  def new
    @practice = current_team.practices.build
    @practice.date = Time.zone.now.change(hour: 14, min: 30)
  end

  def edit
    @practice = Practice.find(params[:id])
  end

  def availability_email
    @practice = Practice.find(params[:id])

    if @practice.created? || @practice.notified_team?
      @practice_email = PracticeMailer.practice_scheduled(@practice,
                                                          current_user.email,
                                                          from:     current_user.name,
                                                          reply_to: current_user.email,
                                                          preview:  true)
    else
      @practice_email = PracticeMailer.practice_updated(@practice,
                                                        current_user.email,
                                                        from:           current_user.name,
                                                        reply_to:       current_user.email,
                                                        recent_changes: @practice.recent_changes,
                                                        preview:        true)
    end
  end

  def notify
    @practice = Practice.find(params[:id])

    if @practice.created? || @practice.notified_team?
      Practice.delay.notify(:scheduled,
                            from:        current_user.name,
                            reply_to:    current_user.email,
                            comments:    params[:comments],
                            practice_id: @practice.id)
    else
      Practice.delay.notify(:updated,
                            from:           current_user.name,
                            reply_to:       current_user.email,
                            comments:       params[:comments],
                            practice_id:    @practice.id,
                            recent_changes: @practice.recent_changes)
    end

    @practice.notified!
    redirect_to team_practices_url(@practice.team), :notice => 'Availability request email sent to team'
  end

  def create
    @practice = current_team.practices.build(permitted_params.practice)

    if @practice.save
      redirect_to team_practices_url(current_team), :notice => 'Practice created'
    else
      render :new
    end
  end

  def update
    @practice = Practice.find(params[:id])

    if @practice.update_attributes(permitted_params.practice)
      if @practice.previous_changes.present?
        if @practice.notified_team? || @practice.updated?
          flash[:notice] = "Practice updated. Send updated email now, or go #{view_context.link_to("back to practices", team_practices_url(@practice.team), :class => "alert-link")}"
          next_url = availability_email_team_practice_url(current_team, @practice)
        end

        @practice.reset_notified!
      end

      if next_url.present?
        redirect_to next_url
      else
        redirect_to team_practices_url(@practice.team), :notice => 'Practice updated'
      end
    else
      render :edit
    end
  end

  def destroy
    @practice = Practice.find(params[:id])
    @practice.destroy

    redirect_to team_practices_url(@practice.team), :notice => 'Practice deleted'
  end

  def availabilities
    @practice = Practice.find(params[:id])
  end
end

