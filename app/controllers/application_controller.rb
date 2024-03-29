class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_member!
  before_action proc { |controller| (controller.action_has_layout = false) if controller.request.xhr? }

  private

  def authorize_admin!
    redirect_to root_url, alert: "Access denied!" unless current_member.admin?
  end

  def restrict_substitute!
    redirect_to root_url, alert: "Access denied!" if current_member.substitute?
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end
end
