class CartItemsController < ApplicationController
  def index
    @shopping_cart = ShoppingCart.find(params[:shopping_cart_id])
  end

  def edit
    @event = Event.find(params[:event_id])
    @product = Product.find(params[:id])
    @cart_item = CartItem.create(shopping_cart_id: params[:shopping_cart_id], product_id: @product.id)
    @shopping_cart = ShoppingCart.find(params[:shopping_cart_id])

    if @cart_item.save
      @shopping_cart.cart_items << @cart_item
      render :index
      # redirect_to event_inventories_path(event: params[:event_id]), notice: "Item added to cart"
    else
      # binding.pry
      render :new
      flash[:notice] = "DID NOT SAVE..."
    end
  end
end
