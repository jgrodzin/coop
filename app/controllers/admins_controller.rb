class AdminsController < ApplicationController
  before_action :authorize_admin!

  def index
  end

  def products
    @products = Product.all.includes(:vendor).group_by(&:vendor)
  end

  def teams
    @teams = Team.all.includes(:team_members)
  end

  def edit_member
    @member = Member.find(params[:member_id])
  end

  def update_member
    @member = Member.find(params[:member_id])

    if @member.update(member_params)
      redirect_to members_path, notice: "Member successfully updated."
    else
      flash.now[:notice] = "Changes could not be saved."
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
