class ProductsController < ApplicationController
  def index
    @event = Event.find(params[:event_id])
    @products = @event.products.group_by(&:vendor)
    @vendor_categories = Vendor.all.map(&:category).uniq.compact
    @shopping_cart = ShoppingCart.find_or_create_by(event: @event, member: current_member)
  end

  # def add_to_cart
  #   @product = Product.find(params[:product_id])
  #   @shopping_cart = ShoppingCart.find_or_create_by(event: @event, member: current_member)
  #   @cart_item = @shopping_cart.cart_items.build(product: @product, price_cents: @product.price_cents)

  #   if @cart_item.save
  #     redirect_to event_inventories_path(event: @event), notice: "Item added to cart"
  #   else
  #     @products = @event.products.group_by(&:vendor)
  #     render :index, notice: "Could not add that item to the cart!"
  #   end
  # end

  def new
    @product = Product.new
  end

  def create
    @event = Event.find(params[:event_id])
    @product = Product.create(product_params)

    if @product.save
      redirect_to event_products_path, notice: "Product successfully added"
    else
      @errors = @product.errors.full_messages
      render :new, notice: "Could not save product"
    end
  end

  def add_to_cart
    @event = Event.find(params[:event_id])
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

  private

  # def set_event
  #   @event = Event.find(params[:event_id])
  # end

  def product_params
    params.require(:product).permit(:name, :vendor_id, :price, :unit_type, :event_id)
  end
end
