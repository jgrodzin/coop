class MembersController < ApplicationController
  before_filter :authorize_admin!, except: [:index, :show]

  def index
    @members = Member.all.includes(:team_members).order(:last_name)
  end

  def show
    @member = Member.find(params[:id])
  end

  def new
    @member = Member.new
  end

  def create
    @member = Member.new(member_params)
    @member.password = Devise.friendly_token.first(8)

    if @member.save
      redirect_to members_path, notice: "Member successfully created"
    else
      flash.now[:alert] = "Could not save member"
      @errors = @member.errors.full_messages
      render :new
    end
  end

  def edit
    @member = Member.find(params[:id])
  end

  def update
    @member = Member.find(params[:id])

    if @member.update(member_params)
      redirect_to members_path, notice: "Member successfully updated"
    else
      flash.now[:notice] = "Member could not be saved..."
      @errors = @member.errors.full_messages
      render :edit
    end
  end

  private

  def member_params
    params.require(:member).permit(:first_name,
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
                                   teams_attributes: [:number, team_membrs_attributes: [:leader]])
  end
end
