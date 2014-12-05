class CartItemsController < ApplicationController
  def index
    @event = Event.find(params[:event_id])
    @shopping_cart = ShoppingCart.find(params[:shopping_cart_id])
    @sorted_cart_items = @shopping_cart.cart_items.joins(:product).merge(Product.order(:name))
  end

  def edit
    @cart_item = CartItem.find(params[:id])
  end

  def update
    @event = Event.find(params[:event_id])
    @shopping_cart = ShoppingCart.find(params[:shopping_cart_id])
    @cart_item = CartItem.find(params[:id])
    @cart_item.amount = params[:cart_item]["amount"]
    ### seems weird.

    if @cart_item.valid?
      @cart_item.save!
      redirect_to event_shopping_cart_cart_items_path(event: @event, shopping_cart: @shopping_cart), notice: "Amount updated"
    else
      flash.now[:alert] = "amount must be a number"
      render :index
    end
  end

  def destroy
    @cart_item = CartItem.find(params[:id])
    @cart_item.destroy

    redirect_to event_shopping_cart_cart_items_path(event: @event, shopping_cart: @shopping_cart), notice: "Product removed from event cart"
  end
end
