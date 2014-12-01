class CartItemsController < ApplicationController
  def index
    @event = Event.find(params[:event_id])
    @shopping_cart = ShoppingCart.find(params[:shopping_cart_id])
  end

  def edit
    @event = Event.find(params[:event_id])
    @product = Product.find(params[:id])
    @cart_item = CartItem.create(shopping_cart_id: params[:shopping_cart_id], product_id: @product.id, price_cents_cents: @product.price_cents)
    @shopping_cart = ShoppingCart.find(params[:shopping_cart_id])

    if @cart_item.save
      @shopping_cart.cart_items << @cart_item
      # render :index
      redirect_to event_inventories_path(event: params[:event_id]), notice: "Item added to cart"
    # else
    #   render :new
    #   flash[:notice] = "DID NOT SAVE..."
    end
  end

  def update
    # enter amount into text field, set that as cart_item.amount
    # have button to update
    @product = Product.find(params[:id])
    @cart_item = CartItem.where(product_id: @product.id)
    @cart_item.update(params[:amount])
  end

  def update
    @event = Event.find(params[:id])
    @event.update(event_params)

    if @event.valid?
      @event.save!
      redirect_to events_path, notice: "Event successfully updated!"
    else
      flash[:notice] = "Event could not be saved..."
      @errors = @event.errors.full_messages
      render :edit
    end
  end
end
