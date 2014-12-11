class ShoppingCartsController < ApplicationController
  def index
    @event = Event.find(params[:event_id])
    @products = @event.products.group_by(&:vendor)
    @shopping_cart = ShoppingCart.find_or_create_by(event: @event, member: current_member)
  end

  def cart_history
  end
end
