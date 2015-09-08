class ProductsController < ApplicationController
  before_action :set_event

  def index
    @products = @event.products.includes(:vendor).order(:name).group_by(&:vendor).sort_by { |vendor, products| vendor.name }
    @product = Product.new
    @vendors = Vendor.active_vendors.order(:name)
    @unit_types = Product::UNIT_TYPES
  end

  def create
    @product = Product.create(product_params)

    if @product.save
      # redirect to event_products_path(vendor_param) to set the vendor dropdown
      redirect_to event_products_path(vendor: @product.vendor.id), notice: "Product added."
    else
      flash[:alert] = "Product could not be saved."
      redirect_to event_products_path(vendor: @product.vendor.id)
    end
  end

  def update
    @product = Product.find(params[:id])
    @product.update(product_params)

    if @product.save
      redirect_to event_products_path(params[:event_id], vendor: @product.vendor.id), notice: "Product updated."
    else
      flash[:alert] = "Product could not be updated."
      redirect_to event_products_path(params[:event_id], vendor: @product.vendor.id)
    end
  end

  def destroy
    @product = @event.products.find(params[:id])
    @product.destroy

    redirect_to event_products_path(params[:event_id]), notice: "Product was removed from this event."
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def product_params
    params.require(:product).permit(:name, :vendor_id, :price, :unit_type, :event_id, :total_amount_purchased)
  end
end
