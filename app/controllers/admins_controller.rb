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

  def archive_member
    @member = Member.find(params[:member_id])
    if @member.active?
      @member.archived!
      @member.team_members.destroy_all
      flash[:notice] = "Member has been removed from all teams and archived."
    else
      flash[:alert] = "Something went wrong! Member could not be archived."
    end
    redirect_to members_path
  end

  def activate_member
    @member = Member.find(params[:member_id])
    if @member.archived?
      @member.active!
      flash[:notice] = "Member has been activated."
    else
      flash[:alert] = "Something went wrong! Member could not be activated."
    end
    redirect_to members_path
  end

  def archive_vendor
    @vendor = Vendor.find(params[:vendor_id])
    if @vendor.active?
      @vendor.archived!
      flash[:notice] = "Vendor has been activated."
    else
      flash[:alert] = "Something went wrong! Vendor could not be activated."
    end
    redirect_to vendors_path
  end

  def activate_vendor
    @vendor = Vendor.find(params[:vendor_id])
    if @vendor.archived?
      @vendor.active!
      flash[:notice] = "Vendor has been activated."
    else
      flash[:alert] = "Something went wrong! Vendor could not be activated."
    end
    redirect_to vendors_path
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
