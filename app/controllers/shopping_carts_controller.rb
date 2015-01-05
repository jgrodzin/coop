class ShoppingCartsController < ApplicationController
  before_filter :set_event_and_shopping_cart

  def index
    @products = @event.products.order(:name).includes(:vendor).group_by(&:vendor).sort_by { |vendor, products| vendor.name }
    @cart_item = @shopping_cart.cart_items.build(product: @product)
  end

  def add_to_cart
    @product = Product.find(params[:product_id])
    @cart_item = CartItem.new(shopping_cart: @shopping_cart, product: @product, amount: params[:cart_item]["amount"])

    if @cart_item.save
      redirect_to event_shopping_carts_path(event: @event), notice: "Item added to cart"
    else
      @products = @event.products.group_by(&:vendor)
      render :index, notice: "Could not add item to cart!"
    end
  end

  private

  def set_event_and_shopping_cart
    @event = Event.includes(:vendors).find(params[:event_id])
    @shopping_cart = ShoppingCart.find_or_create_by(event: @event, member: current_member)
  end

  # def cart_item_params
  #   params.require(:cart_item).permit(:shopping_cart_id, :product_id, :amount)
  # end
end
