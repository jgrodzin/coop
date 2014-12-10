class ProductsController < ApplicationController
  before_filter :set_event, only: [:index, :create, :add_to_cart, :destroy]

  def index
    @products = @event.products.group_by(&:vendor)
    @vendor_categories = Vendor.all.map(&:category).uniq.compact
    @shopping_cart = ShoppingCart.find_or_create_by(event: @event, member: current_member)
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.create(product_params)

    if @product.save
      redirect_to event_products_path, notice: "Product successfully added"
    else
      @errors = @product.errors.full_messages
      render :new, notice: "Could not save product"
    end
  end

  def add_to_cart
    @product = Product.find(params[:product_id])
    @shopping_cart = ShoppingCart.find_or_create_by(event: @event, member: current_member)
    @cart_item = @shopping_cart.cart_items.build(product: @product, price_cents: @product.price_cents)

    if @cart_item.save
      redirect_to event_products_path(event: @event), notice: "Item added to cart"
    else
      @products = @event.products.group_by(&:vendor)
      render :index, notice: "Could not add item to cart!"
    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    @product.update(product_params)
    if @product.save
      redirect_to event_products_path(params[:event_id]), notice: "Product successfully updated!"
    else
      @errors = @product.errors.full_messages
      render :edit, notice: "Could not update product!"
    end
  end

  def destroy
    @product = @event.products.find(params[:id])
    @product.destroy

    redirect_to event_products_path(params[:event_id]), notice: "Product was removed from this event"
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def product_params
    params.require(:product).permit(:name, :vendor_id, :price_cents, :unit_type, :event_id)
  end
end
