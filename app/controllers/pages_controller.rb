class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:landing_page]

  # layout "landing_page"

  def index
  end

  def landing_page
  end
end
