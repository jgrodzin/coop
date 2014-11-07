class ShoppingCartsController < ApplicationController
  def index
    # @inventory = Inventory.where(event_id: params[:event_id])
    # not in params!
    # @shopping_cart = current_member.shopping_carts
    # @order_items
    @inventories = Inventory.where(event_id: Event.first)
    @products = @inventories.map(&:product).sort_by(&:vendor)
    @event = @inventories.map(&:event).first
  end
end
