class TeamMembersController < ApplicationController
  before_filter :authorize_admin!

  def new
    @team_member = TeamMember.new
  end

  def create
    @team = Team.find(params[:id])
    @member = Member.find(params[:member_id])
    @team.team_member.create(member_id: @member.id)
    @team.save
  end

  def destroy
    binding.pry
    @team = Team.find(params[:id])
    @team.team_members_attributes = { id: params[:member_id], _destroy: "1" }
    @team.save
    @team.reload
    redirect_to teams_admins_path
  end
end
