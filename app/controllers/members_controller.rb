class MembersController < ApplicationController
  before_filter :authorize_admin!, except: [:index, :show]

  def index
    @members = Member.all.order(:last_name)
  end

  def show
    @member = Member.find(params[:id])
  end

  def new
    @member = Member.new
  end

  def create
    @member = Member.new(member_params)

    if @member.save
      redirect_to members_path, notice: "Member successfully created"
    else
      flash.now[:alert] = "Could not save member"
      @errors = @member.errors.full_messages
      render :new
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
                                   :password)
  end
end
