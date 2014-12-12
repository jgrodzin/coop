class ShoppingCartsController < ApplicationController
  def index
    @event = Event.find(params[:event_id])
    @products = @event.products.group_by(&:vendor)
    @shopping_cart = ShoppingCart.find_or_create_by(event: @event, member: current_member)
  end

  def show
  end

  def cart_history
  end

  def add_to_cart
    @event = Event.find(params[:event_id])
    @product = Product.find(params[:product_id])
    @shopping_cart = ShoppingCart.find_or_create_by(event: @event, member: current_member)
    @cart_item = @shopping_cart.cart_items.build(product: @product)

    if @cart_item.save
      redirect_to event_shopping_carts_path(event: @event), notice: "Item added to cart"
    else
      @products = @event.products.group_by(&:vendor)
      render :index, notice: "Could not add item to cart!"
    end
  end
end
