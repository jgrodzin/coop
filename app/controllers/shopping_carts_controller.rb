class ShoppingCartsController < ApplicationController
  def index
    @event = Event.find(params[:event_id])
    @cart = ShoppingCart.where(event_id: @event.id)
    @products = @event.inventories.map(&:product)
    # @quantity = params[:input]
  end
end
