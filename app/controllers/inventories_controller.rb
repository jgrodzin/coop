class InventoriesController < ApplicationController
  before_action :set_inventory
  before_action :authenticate_member!

  def index
    @products = @inventories.map(&:product).sort_by(&:vendor)
    @event = @inventories.map(&:event).first
  end

  def show
    @vendors = Vendor.all
  end

  def new
    @inventory = Inventory.new
    @product = Product.new
  end

  def create
    @product = Product.create(product_params)
    @event = Event.find(params[:event_id])
    @inventory = Inventory.create(product_id: @product.id, event_id: @event.id)

    if @product.save
      redirect_to event_inventories_path, notice: "Product successfully added"
    else
      flash.now[:alert] = "Could not save product"
      @errors = @product.errors.full_messages
      render :new
    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    @product.update(product_params)

    if @product.valid?
      @product.save!
      redirect_to event_inventories_path(params[:event_id]), notice: "Product successfully updated!"
    else
      flash.now[:alert] = "Could not save!"
      @errors = @product.errors.full_messages
      render :edit
    end
  end

  private

  def set_inventory
    @inventories = Inventory.where(event_id: params[:event_id])
  end

  def product_params
    params.require(:product).permit(:name, :vendor_id, :price, :unit_type)
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
