class InventoriesController < ApplicationController
  before_action :set_event, only: [:index, :add_to_cart, :create]

  def index
    @products = @event.products.group_by(&:vendor)
    @shopping_cart = ShoppingCart.find_or_create_by(event: @event, member: current_member)
  end

  def add_to_cart
    @product = Product.find(params[:product_id])
    @shopping_cart = ShoppingCart.find_or_create_by(event: @event, member: current_member)
    @cart_item = @shopping_cart.cart_items.build(product: @product, price_cents_cents: @product.price_cents)

    if @cart_item.save
      redirect_to event_inventories_path(event: @event), notice: "Item added to cart"
    else
      @products = @event.products.group_by(&:vendor)
      render :index, notice: "Could not add that item to the cart!"
    end
  end

  def new
    @inventory = Inventory.new
    @product = Product.new
  end

  def create
    @product = Product.create(product_params)

    if @product.save
      Inventory.create(product_id: @product.id, event_id: @event.id)
      redirect_to event_inventories_path, notice: "Product successfully added"
    else
      @errors = @product.errors.full_messages
      render :new, notice: "Could not save product"
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
      @errors = @product.errors.full_messages
      render :edit, notice: "Could not save!"
    end
  end

  def destroy
    @product = Inventory.find(params[:id])
    @product.destroy

    redirect_to event_inventories_path(params[:event_id]), notice: "Produt was removed from event inventory"
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def product_params
    params.require(:product).permit(:name, :vendor_id, :price, :unit_type)
  end
end
