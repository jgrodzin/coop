class MembersController < ApplicationController
  before_action :authorize_admin!, only: [:new, :create, :archives]
  before_action :restrict_substitute!, except: [:show, :edit_account, :update]

  def index
    @members = Member.active_members.includes(:team_members).order(:first_name)
    @substitutes = Member.substitue_users.order(:first_name)
  end

  def archives
    @members = Member.archived_members.order(:first_name)
  end

  def show
    if current_member.substitute? && params[:id] == current_member.id.to_s
      @member = current_member
    elsif current_member.substitute? && params[:id] != current_member.id.to_s
      redirect_to root_url
    else
      @member = Member.find(params[:id])
    end
  end

  def new
    @member = Member.new
  end

  def create
    @member = Member.new(member_params)
    @member.password = "password" # SecureRandom.hex(20)

    if @member.save
      redirect_to members_path, notice: "Member successfully created"
    else
      flash.now[:alert] = "Could not save member"
      @errors = @member.errors.full_messages
      render :new
    end
  end

  def edit_account
    if params[:member_id] == current_member.id.to_s
      @member = current_member
    else
      redirect_to root_path, alert: "You do not have access to that page."
    end
  end

  def update
    @member = current_member

    if @member.update(member_params)
      redirect_to root_path, notice: "Your account has been updated."
    else
      flash.now[:alert] = "Changes could not be saved."
      @errors = @member.errors.full_messages
      render :edit_account
    end
  end

  private

  def member_params
    params.require(:member).permit(
      :first_name,
      :last_name,
      :phone,
      :street_address,
      :unit_number,
      :city,
      :state,
      :zip,
      :email,
      :password,
      :admin,
      :status,
      teams_attributes: [:number, team_membrs_attributes: [:leader]])
  end
end
