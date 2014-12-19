class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:landing_page]

  def index
  end

  def landing_page
  end

  # def foo
  #   render json: { stuff: "foo" }
  # end
end
