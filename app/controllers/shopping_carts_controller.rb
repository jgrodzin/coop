class ShoppingCartsController < ApplicationController
  # before_action :set_shopping_cart

  def index
    @cart = ShoppingCart.find_or_create_by(event: params[:event_id], member: current_member)
    @event = Event.find(params[:event_id])
    # @cart = ShoppingCart.where(event_id: @event.id, member: current_member)
    @products = @event.products
  end

  def show
    @cart = ShoppingCart.find_or_create_by(event: params[:event_id], member: current_member)
    @event = Event.find(params[:event_id])
    @cart_item = CartItem.new
  end

  def new
  end

  private

  def set_shopping_cart
    @cart = ShoppingCart.find_or_create_by(event: params[:event_id], member: current_member)
  end
end
