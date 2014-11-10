class OrderItemsController < ApplicationController
  def create
    @shopping_cart = ShoppingCart.find(params[:id])
    @order_items = @shopping_cart.order_items.new(order_items_params)
    @order.save
    # session[:order_id] = @order.id
  end

  def update
  end

  def destroy
  end

  private

  def order_items_params
    params.require(:order_items).permit(:quantity, :product_id)
  end
end
