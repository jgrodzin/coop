class ShoppingCartsController < ApplicationController
  before_action :set_event_and_shopping_cart, except: [:show]
  # before_action :authorize_admin!, only: [:history]
  before_action :restrict_members_to_their_price_sheets

  def index
    @products = @event.products.order(:name).includes(:vendor).group_by(&:vendor).sort_by { |vendor, products| vendor.name }
    @new_cart_item = @shopping_cart.cart_items.build(product: @product)
  end

  def add_to_cart
    @product = Product.find(params[:product_id])
    if params[:cart_item][:amount] == ""
      amount = "0.0"
    else
      amount = params[:cart_item][:amount]
    end

    @cart_item = CartItem.create(shopping_cart: @shopping_cart, product: @product, amount: amount)
    if @cart_item.save
      render json: @shopping_cart.cart_items, notice: "Adding products to cart via AJAX"
    else
      @errors = @cart_item.errors.full_messages
      render json: { errors: @errors }
    end
  end

  def history
    @past_carts = ShoppingCart.where(event_id: @event.id)
  end

  def show
    @shopping_cart = ShoppingCart.find(params[:id])
    @cart_items = @shopping_cart.cart_items
    @event = Event.find(@shopping_cart.event_id)
    @products = @event.products.order(:name).includes(:vendor).group_by(&:vendor).sort_by { |vendor, products| vendor.name }
  end

  private

  def set_event_and_shopping_cart
    @event = Event.includes(:vendors).find(params[:event_id])
    @shopping_cart = ShoppingCart.find_or_create_by(event: @event, member: current_member)
  end

  def restrict_members_to_their_price_sheets
    unless current_member.admin?
      redirect_to root_url unless current_member.shopping_carts.map(&:id).include?(@shopping_cart.id)
    end
  end
end
