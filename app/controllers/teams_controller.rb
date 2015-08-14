class TeamsController < ApplicationController
  before_action :authorize_admin!, except: [:index, :show]

  def index
    @teams = current_member.teams if current_member.teams.present?
  end

  def new
    @members = Member.active_members.order(:first_name)
    @team = Team.new
  end

  def show
    @team = Team.find(params[:id])
  end

  def create
    team_attributes = team_params
    member_ids = team_attributes.delete(:member_ids).reject(&:empty?)
    leader_ids = team_attributes.delete(:leader_ids).reject(&:empty?)
    @team = Team.new(team_attributes)

    if leader_ids.blank? && member_ids.blank?
      @errors = @team.errors.full_messages << "A team must have members"
      render_could_not_save
    elsif @team.save
      create_team_members(member_ids)
      create_team_leaders(leader_ids)
      redirect_to teams_admins_path, notice: "Team successfully created"
    else
      @errors = @team.errors.full_messages
      render_could_not_save
    end
  end

  def edit
    @members = Member.active_members.order(:first_name)
    @team = Team.find(params[:id])
  end

  def update
    team_attributes = team_params
    member_ids = team_attributes.delete(:member_ids).reject(&:empty?)
    leader_ids = team_attributes.delete(:leader_ids).reject(&:empty?)
    @team = Team.find(params[:id])

    if leader_ids.blank? && member_ids.blank?
      @errors = @team.errors.full_messages << "A team must have members"
      render_could_not_save
    elsif @team.update(team_attributes)
      @team.team_members.destroy_all
      create_team_members(member_ids)
      create_team_leaders(leader_ids)
      redirect_to teams_admins_path, notice: "Team Successfully updated"
    else
      @errors = @team.errors.full_messages
      render_could_not_save
    end
  end

  private

  def team_params
    params.require(:team).permit(:name, :number, leader_ids: [], member_ids: [])
  end

  def create_team_members(member_ids)
    member_ids.each do |id|
      TeamMember.create(member_id: id, team_id: @team.id)
    end
  end

  def create_team_leaders(leader_ids)
    leader_ids.each do |id|
      tm = TeamMember.find_or_create_by(member_id: id, team_id: @team.id)
      tm.leader = true
      tm.save
    end
  end

  def render_could_not_save
    flash.now[:alert] = "Could not save new team."
    @members = Member.active_members.order(:first_name)
    if params[:action] == "create"
      render :new
    else
      render :edit
    end
  end
end
