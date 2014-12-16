class TeamsController < ApplicationController
  def index
    unless current_member.teams.empty?
      @teams = current_member.teams
    end
  end

  def show
    current_member
    @my_team = Team.find(params[:id])
  end
end
