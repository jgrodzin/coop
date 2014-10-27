class EventProductsController < ApplicationController
  def index
    set_event_product
    @products = @event_products.map(&:product)
    @event = @event_products.map(&:event).first
  end

  def show
    set_event_product
    @vendors = Vendor.all
  end

  def new
    @product = Product.new
  end

  def create
     # @product = Product.new
  end

  def edit
    set_event_product
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    @event = Event.find(params[:event_id])

    @product.name = params[:product]["name"]
    @product.price = params[:product]["price"]
    # binding.pry
    @product.unit_type = params[:product]["unit_type"]
    @product.vendor_id = params[:product]["vendor_id"]

    if @product.valid?
      @product.save!
      redirect_to event_event_products_path(params[:event_id]), notice: "Product successfully updated!"
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
