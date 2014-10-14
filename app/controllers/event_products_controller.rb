class EventProductsController < ApplicationController
  def index
    set_event_product
    @products = @event_products.map(&:product)
  end

  def show
    set_event_product
    @product = Product.find(params[:id])
  end

  def edit
    set_event_product
  end

  def update
    set_event_product
    @event = Event.find(params[:id])
    @product = Product.find(params[:id])

    @product.name = params[:product]["name"]
    @product.description = params[:product]["description"]

    if @product.valid?
      @product.save!
      redirect_to event_event_products_path, notice: "Product successfully updated!"
    end
  end

  private

  def set_event_product
    @event_products = EventProduct.where(event_id: params[:event_id])
  end
end

# events....
# has a price sheet with EventProducts
# price sheets only show products for specific event!

# current order ==> is same as Event Products?
# Should hold ALL information regarding the order...
## product info: quantity purchased, vendors, etc.
## CRUD functionality here.

## What is Products doing now? ALl prodcuts not really necessary
# Does EventProducts get informoation from products still... or is that moot.

## gonna need that nested route
# event/1/event_products
