class CartItemsController < ApplicationController
  def index
    @event = Event.find(params[:event_id])
    @shopping_cart = ShoppingCart.find(params[:shopping_cart_id])
  end

  def update
    # enter amount into text field, set that as cart_item.amount
    # have button to update
    # @product = Product.find(params[:id])
    # @cart_item = CartItem.where(product_id: @product.id)
    # @cart_item.update(params[:amount])
  end
end
