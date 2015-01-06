class TeamsController < ApplicationController
  before_filter :authorize_admin!

  def index
    @teams = current_member.teams unless current_member.teams.empty?
  end

  def show
    current_member
    @my_team = Team.find(params[:id])
  end

  def new
    @team = Team.new
  end

  def create
    @team = Team.new(team_params)

    if @team.save
      redirect_to teams_admins_path, notice: "Team successfully created"
    else
      flash.now[:alert] = "Could not save new team"
      @errors = @team.errors.full_messages
      render :new
    end
  end

  def edit
    @team = Team.find(params[:id])
    @team_members = TeamMember.where(team_id: params[:id])
  end

  def update
    @team_members = TeamMember.where(team_id: params[:id])
    @team = Team.find(params[:id])
    @team.update(team_params)

    if @team.save
      redirect_to teams_admins_path, notice: "Team Successfully updated"
    else
      @errors = @team.errors.full_messages
      render :edit, notice: "Could not update team!"
    end
  end

  private

  def team_params
    params.require(:team).permit(:name, :number, team_members_attributes: [:id, :member_id])
  end
end
