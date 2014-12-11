class AdminsController < ApplicationController
  before_action :authenticate_admin!

  def index
  end

  private

  def authenticate_admin!
    redirect_to root_url unless current_member.admin?
  end
end
