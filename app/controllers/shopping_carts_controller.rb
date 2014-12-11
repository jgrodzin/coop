class ShoppingCartsController < ApplicationController
  # before_action :set_shopping_cart

  def index
    @event = Event.find(params[:event_id])
    @products = @event.products.group_by(&:vendor)
    @shopping_cart = ShoppingCart.find_or_create_by(event: @event, member: current_member)
  end

### not implemented
  # def show
  #   @shopping_cart = ShoppingCart.find_or_create_by(event: params[:event_id], member: current_member)
  #   @event = Event.find(params[:event_id])
  #   @cart_item = CartItem.new
  # end

  def new
  end

  private

  def set_shopping_cart
    @cart = ShoppingCart.find_or_create_by(event: params[:event_id], member: current_member)
  end
end
