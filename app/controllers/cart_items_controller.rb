class CartItemsController < ApplicationController
  def index
    @event = Event.find(params[:event_id])
    @shopping_cart = ShoppingCart.find(params[:shopping_cart_id])
  end

  def edit
    @cart_item = CartItem.find(params[:id])
  end

  def update
    @event = Event.find(params[:event_id])
    @shopping_cart = ShoppingCart.find(params[:shopping_cart_id])
    @cart_item = CartItem.find(params[:id])
    @cart_item.amount = params[:cart_item]["amount"]

    if @cart_item.valid?
      @cart_item.save!
      redirect_to event_shopping_cart_cart_items_path(event: @event, shopping_cart: @shopping_cart), notice: "Amount updated"
    else
      render :index, notice: "WHOOPS couldn't save amount"
    end
  end
end
