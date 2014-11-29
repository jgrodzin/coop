class TeamsController < ApplicationController
  def index
    # @teams = Team.all
    # @team_members = TeamMember.all
    @team_member = TeamMember.where(member_id: current_member.id)
    @my_team = Team.where(id: @team_member.first.team_id)
  end

  def show
    current_member
    @my_team = Team.find(params[:id])
  end
end
