class InventoriesController < ApplicationController
  def index
    set_inventory
    @products = @inventories.map(&:product)
    @event = @inventories.map(&:event).first
  end

  def show
    set_inventory
    @vendors = Vendor.all
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.create(params[:product])

    if @product.save
      redirect_to event_inventories_path, notice: "Product successfully added"
    else
      flash.now[:alert] = "Could not save product"
      @errors = @product.errors.full_messages
      render :new
    end
  end

  def edit
    set_inventory
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
      redirect_to event_inventories_path(params[:event_id]), notice: "Product successfully updated!"
    else
      flash.now[:alert] = "Could not save!"
      @errors = @product.errors.full_messages
      render :_form
    end
  end

  private

  def set_inventory
    @inventories = Inventory.where(event_id: params[:event_id])
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
# event/1/inventories
