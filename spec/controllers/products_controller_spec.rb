require "rails_helper"

describe ProductsController, type: :controller do
  let!(:member) { FactoryGirl.create(:member) }
  let!(:event) { FactoryGirl.create(:event) }

  before do
    sign_in member
  end

  describe "#index" do
    render_views

    it "renders a view" do
      get :index, event_id: event.id
      expect(response).to render_template(:index)
    end

    it "sets products for the event from inventory" do
      products = FactoryGirl.create_list(:product, 10, event_id: event.id)
      get :index, event_id: event.id
      expect(assigns(:event).products).to eq(products)
    end

    describe "sets shopping cart" do
      it "finds an existing shopping cart" do
        member.shopping_carts << FactoryGirl.create(:shopping_cart, event: event, member: member)
        expect do
          get :index, event_id: event.id
        end.to_not change { member.shopping_carts.count }
      end
    end

    it "displays product in correct order (alphabetically)" do
      vendor = FactoryGirl.create(:vendor)
      z_product = FactoryGirl.create(:product, name: "Zebra", event: event, vendor_id: vendor.id)
      a_product = FactoryGirl.create(:product, name: "Alligator", event: event, vendor_id: vendor.id)
      h_product = FactoryGirl.create(:product, name: "Hippo", event: event, vendor_id: vendor.id)
      get :index, event_id: event.id

      expect(assigns(:products)).to eq([[vendor, [a_product, h_product, z_product]]])
    end
  end

  describe "#create" do
    context "with valid params" do
      let(:vendor) { FactoryGirl.create :vendor }
      let(:product_params) do
        {
          product: attributes_for(:product, vendor_id: vendor.id, event_id: event.id),
          event_id: event.id
        }
      end

      it "creates a product for event" do
        expect do
          post :create, product_params
        end.to change { event.products.count }.by(1)
      end

      it "redirects to event products path" do
        post :create, product_params
        expect(response).to redirect_to(event_products_path(vendor: Product.last.vendor.id))
      end

      it "sets the notice message appropriately" do
        post :create, product_params
        expect(flash[:notice]).to be_present
      end
    end

    context "invalid params" do
      let(:invalid_product_params) do
        {
          product: attributes_for(:product),
          event_id: event.id
        }
      end

      xit "redirects to index page if product is not persisted" do
        post :create, invalid_product_params
        expect(response).to redirect_to(event_products_path(vendor: Product.find_by.last.vendor.id))
      end

      xit "sets the notice message appropriately" do
        post :create, invalid_product_params
        expect(flash[:alert]).to be_present
      end

      xit "does not create a new Product object" do
        expect do
          post :create, invalid_product_params
        end.to_not change(Product, :count)
      end
    end
  end

  describe "#update" do
    let!(:original_vendor) { FactoryGirl.create(:vendor) }
    let!(:updated_vendor) { FactoryGirl.create(:vendor) }
    let!(:product) { FactoryGirl.create(:product, name: "Choco Taco", price_cents: 100, unit_type: "each", vendor_id: original_vendor.id, event: event) }
    let!(:updated_params) { attributes_for(:product, name: "Twinkie", price: 400, unit_type: "bag", vendor_id: updated_vendor.id, event: event) }

    context "name" do
      it "updates the name" do
        product.name = updated_params[:name]
        put :update, event_id: event.id, id: product.id, product: product.attributes
        expect(Product.find(product.id).name).to eq(updated_params[:name])
      end

      it "displays products alphabetically after update" do
        z_product = FactoryGirl.create(:product, name: "Zebra", event: event, vendor_id: original_vendor.id)
        a_product = FactoryGirl.create(:product, name: "Alligator", event: event, vendor_id: original_vendor.id)
        h_product = FactoryGirl.create(:product, name: "Hippo", event: event, vendor_id: original_vendor.id)

        product.name = updated_params[:name]
        put :update, event_id: event.id, id: product.id, product: product.attributes
        get :index, event_id: event.id

        expect(assigns(:products)).to eq([[original_vendor, [a_product, h_product, product, z_product]]])
      end
    end

    it "updates the price" do
      put :update, event_id: event.id, id: product.id, product: updated_params
      product.reload
      expect(product.price.dollars).to eq(updated_params[:price])
    end

    it "updates the unit type" do
      product.unit_type = updated_params[:unit_type]
      put :update, event_id: event.id, id: product.id, product: product.attributes
      expect(Product.find(product.id).unit_type).to eq(updated_params[:unit_type])
    end

    it "updates the vendor" do
      product.vendor_id = updated_params[:vendor_id]
      put :update, event_id: event.id, id: product.id, product: product.attributes
      expect(Product.find(product.id).vendor_id).to eq(updated_params[:vendor_id])
    end
  end

  describe "#destroy" do
    let!(:product) { FactoryGirl.create(:product, event: event) }

    it "it destroys and removes product from event" do
      expect do
        delete :destroy, event_id: event.id, id: product.id
      end.to change(Product, :count).from(1).to(0)
    end
  end
end
