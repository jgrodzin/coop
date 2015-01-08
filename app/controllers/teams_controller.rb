class TeamsController < ApplicationController
  before_filter :authorize_admin!, except: [:index, :show]

  def index
    @teams = current_member.teams unless current_member.teams.empty?
  end

  def new
    @team = Team.new
  end

  def create
    team_attributes = team_params
    member_ids = team_attributes.delete(:member_ids)
    @team = Team.new(team_attributes)

    if @team.save
      member_ids.select(&:present?).each do |id|
        TeamMember.create!(member_id: id, team_id: @team.id)
      end
      redirect_to teams_admins_path, notice: "Team successfully created"
    else
      flash.now[:alert] = "Could not save new team"
      @errors = @team.errors.full_messages
      render :new
    end
  end

  def edit
    @team = Team.find(params[:id])
  end

  def update
    @team = Team.find(params[:id])
    @team.update(team_params)
    # @team.save
    # tm = TeamMember.find_or_create_by(member: Member.find(params[:team][:leader_ids]))
    # tm.leader = true
    # tm.save

    if @team.save
      redirect_to teams_admins_path, notice: "Team Successfully updated"
    else
      @errors = @team.errors.full_messages
      render :edit, notice: "Could not update team!"
    end
  end

  private

  def team_params
    params
      .require(:team)
      .permit(
        :name,
        :number,
        # leader_ids: [],
        # team_member_ids: [],
        member_ids: [])
  end
end
