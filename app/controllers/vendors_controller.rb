class VendorsController < ApplicationController
  def index
    @vendors = Vendor.all
  end

  def show
    @vendor = Vendor.find(params[:id])
    @vendor_products = Product.where(vendor_id: params[:id])
  end

  def new
    @vendor = Vendor.new
  end

  def create
    @vendor = Vendor.new(vendor_params)

    if @vendor.save
      redirect_to vendors_path, notice: "Vendor successfully created"
    else
      flash.now[:alert] = "Could not save vendor...."
      @errors = @vendor.errors.full_messages
      render :new
    end
  end

  def edit
    @vendor = Vendor.find(params[:id])
  end

  def update
    @vendor = Vendor.find(params[:id])

    if @vendor.update(vendor_params)
      redirect_to vendors_path, notice: "Vendor successfully updated"
    else
      flash.now[:notice] = "Event could not be saved..."
      @errors = @event.errors.full_messages
      render :edit
    end
  end

  def destroy
    @vendor = Vendor.find(params[:id])
    @vendor.destroy
    redirect_to vendors_path, notice: "Vendor and products were deleted"
  end

  private

  def vendor_params
    params.require(:vendor).permit(:name, :rep, :category, :address, :payment)
  end
end
