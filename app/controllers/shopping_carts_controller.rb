class ShoppingCartsController < ApplicationController
  def index
    # @shopping_cart = current_member.shopping_carts
    # @order_items
    @event = Event.find(params[:event_id])
    @inventory = Inventory.where(event_id: @event.id)
    @products = @inventory.map(&:product).sort_by(&:vendor)
    # @ordered_products
    @quantity = params[:input]
  end

  def show
    # @order_items = Event.find(params[:event_id])
    @order_items = ShoppingCart.find(params[:id]).order_items
  end
end
