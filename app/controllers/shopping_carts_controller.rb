class ShoppingCartsController < ApplicationController
  before_action :set_event_and_shopping_cart, except: [:history, :show]

  def index
    @products = @event.products.order(:name).includes(:vendor).group_by(&:vendor).sort_by { |vendor, products| vendor.name }
    @new_cart_item = @shopping_cart.cart_items.build(product: @product)
  end

  def add_to_cart
    @product = Product.find(params[:product_id])
    @cart_item = CartItem.create(shopping_cart: @shopping_cart, product: @product, amount: params[:cart_item]["amount"])
    if @cart_item.save
      render json: @shopping_cart.cart_items, notice: "WHAT WHAT HWAT"
    else
      @errors = @cart_item.errors.full_messages
      render json: { errors: @errors }
    end
  end

  def history
    @past_carts = ShoppingCart.where(member: current_member).includes(:cart_items)
  end

  def show
    @shopping_cart = ShoppingCart.find(params[:id])
  end

  private

  def set_event_and_shopping_cart
    @event = Event.includes(:vendors).find(params[:event_id])
    @shopping_cart = ShoppingCart.find_or_create_by(event: @event, member: current_member)
  end
end
