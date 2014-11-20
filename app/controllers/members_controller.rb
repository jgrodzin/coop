class MembersController < ApplicationController
  def index
    @members = Member.all.order(
      :last_name)
  end

  def show
    @member = Member.find(params[:id])
  end

  def new
    @new_member = Member.new(params[:member_params])
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
                                   :password )
  end
end
