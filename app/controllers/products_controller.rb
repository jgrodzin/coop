class ProductsController < ApplicationController
  before_action :set_event

  def index
    @products = @event.products.includes(:vendor).order(:name).group_by(&:vendor).sort_by { |vendor, products| vendor.name }
    @product = Product.new
    @vendors = Vendor.all.order(:name)
    @unit_types = Product.uniq.pluck(:unit_type)
  end

  def create
    @product = Product.create(product_params)

    if @product.save
      redirect_to event_products_path, notice: "Product successfully added"
    else
      @errors = @product.errors.full_messages
      redirect_to event_products_path, notice: "Could not save product"
    end
  end

  def update
    @product = Product.find(params[:id])
    @product.update(product_params)

    if @product.save
      redirect_to event_products_path(params[:event_id]), notice: "Product successfully updated!"
    else
      @errors = @product.errors.full_messages
      render :index, notice: "Could not update product!"
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
    params.require(:product).permit(:name, :vendor_id, :price, :unit_type, :event_id, :total_amount_purchased)
  end
end
