class ShoppingCartsController < ApplicationController
  def index
    @event = Event.find(params[:event_id])
    @inventory = Inventory.where(event_id: @event.id)
    @products = @inventory.map(&:product)
    # @quantity = params[:input]
  end
end
