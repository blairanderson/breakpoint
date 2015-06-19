class TeamMembersController < ApplicationController
  layout 'team'

  def send_welcome_email
    @team_member = TeamMember.find(params[:id])
    authorize @team_member

    @team_member.send_welcome!(current_user.id)
    redirect_to team_team_members_url(current_team), :notice => 'Welcome email sent'
  end

  def new
    authorize current_team

    emails = SimpleTextAreaParser.parse(params[:emails] || "")
    @add_team_members = AddTeamMembers.users_from_emails(current_team, emails)
  end

  def create
    authorize current_team

    @add_team_members = AddTeamMembers.new(params[:add_team_members])
    if @add_team_members.save(current_team)
      redirect_to team_team_members_url(current_team), notice: "Team members added"
    else
      render :action => 'new'
    end
  end

  def index
    @team_members_welcome_email_unsent = current_team.team_members.welcome_email_unsent
    @team_members = current_team.team_members.welcome_email_sent
    @captain = TeamPolicy.new(current_user, current_team).captain?
  end

  def edit
    @team_member = TeamMember.find(params[:id])
    authorize @team_member
  end

  def update
    @team_member = TeamMember.find(params[:id])
    authorize @team_member

    if @team_member.update(permitted_params.team_member)
      redirect_to team_team_members_url(@team_member.team), :notice => 'Team member updated'
    else
      render :edit
    end
  end

  def destroy
    @team_member = TeamMember.find(params[:id])
    authorize @team_member

    DestroysTeamMember.new(@team_member).destroy

    if current_user.id == @team_member.user_id
      redirect_to teams_url, :notice => 'You have removed yourself from the team'
    else
      redirect_to team_team_members_url(@team_member.team), :notice => 'Team member is now removed from the team'
    end
  end
end

