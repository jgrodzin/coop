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
end
