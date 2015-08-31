class PagesController < ApplicationController
  skip_before_action :authenticate_member!, only: [:landing_page]

  def index
  end

  def landing_page
  end
end
