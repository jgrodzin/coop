class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_member!

  private

  def authorize_admin!
    redirect_to root_url, alert: "Access denied!" unless current_member.admin?
  end
end
