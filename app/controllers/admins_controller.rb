class AdminsController < ApplicationController
  before_action :authorize_admin!

  def index
  end

  def products
    @products = Product.all.group_by(&:vendor)
  end
end
