class TeamsController < ApplicationController
  def index
    @teams = current_member.teams unless current_member.teams.empty?
  end

  def show
    current_member
    @my_team = Team.find(params[:id])
  end

  def new
    @team = Team.new(team_params)
  end

  def edit
    @team = Team.find(params[:id])
  end

  def update
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
    params.require(:team).permit(:name, :number)
  end
end
