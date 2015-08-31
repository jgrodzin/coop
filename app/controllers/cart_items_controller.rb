class CartItemsController < ApplicationController
  before_action :set_event_and_shopping_cart, only: [:index, :update]

  def index
    @sorted_cart_items = @shopping_cart.cart_items.joins(:product).merge(Product.order(:name))
    @shopping_cart.total = @shopping_cart.total_price
    @shopping_cart.save
  end

  def edit
    @cart_item = CartItem.find(params[:id])
  end

  def update
    @cart_item = CartItem.find(params[:id])
    @cart_item.amount = params[:cart_item]["amount"]

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
    if params[:from]
      redirect_to event_shopping_carts_path(event: @event), notice: "Product removed from shopping cart"
    else
      redirect_to event_shopping_cart_cart_items_path(event: @event, shopping_cart: @shopping_cart), notice: "Product removed from shopping cart"
    end
  end

  private

  def set_event_and_shopping_cart
    @event = Event.find(params[:event_id])
    @shopping_cart = ShoppingCart.find(params[:shopping_cart_id])
  end
end
