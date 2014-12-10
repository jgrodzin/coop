require "rails_helper"

describe ProductsController, type: :controller do
  let!(:member) { FactoryGirl.create(:member) }
  let!(:event) { FactoryGirl.create(:event) }

  before do
    sign_in member
  end

  describe "#index" do
    let!(:products) { FactoryGirl.create_list(:product, 10, event_id: event.id) }
    render_views

    it "renders a view" do
      get :index, event_id: event.id
      expect(response).to render_template(:index)
    end

    it "sets products for the event from inventory" do
      get :index, event_id: event.id
      expect(assigns(:event).products).to eq(products)
    end

    describe "sets shopping cart" do
      it "creates a shopping cart if one does not exist" do
        expect(member.shopping_carts.where(event_id: event.id)).to be_empty
        expect { get :index, event_id: event.id  }.to change { member.shopping_carts.count }.by(1)
      end

      it "finds an existing shopping cart" do
        member.shopping_carts << FactoryGirl.create(:shopping_cart, event: event, member: member)
        expect { get :index, event_id: event.id  }.to change { member.shopping_carts.count }.by(0)
      end
    end
  end

  describe "#new" do
    before { get :new, event_id: event.id }

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "builds a new product object" do
      expect(assigns(:product)).to be_kind_of(Product)
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

      it "creates a product" do
        expect do
          post :create, product_params
        end.to change(Product, :count).from(0).to(1)
      end

      it "redirects to event products path" do
        post :create, product_params
        expect(response).to redirect_to(event_products_path)
      end

      it "sets the notice message appropriately" do
        post :create, product_params
        expect(flash[:notice]).to eq("Product successfully added")
      end
    end

    context "invalid params" do
      let(:invalid_product_params) do
        {
          product: attributes_for(:product),
          event_id: event.id
        }
      end

      it "re-renders the new form if the product is not persisted" do
        post :create, invalid_product_params
        expect(response).to render_template(:new)
      end

      it "does not create a new Product object" do
        expect do
          post :create, invalid_product_params
        end.to_not change(Product, :count)
      end
    end
  end

  describe "#add_to_cart" do
    let(:product) { FactoryGirl.create(:product, event: event) }

    it "builds a new cart item for shopping cart" do
      post :add_to_cart, event_id: event.id, product_id: product.id
      expect(assigns(:cart_item)).to be_kind_of(CartItem)
    end

    describe "sets shopping cart" do
      it "creates a shopping cart if one does not exist" do
        expect(member.shopping_carts.where(event_id: event.id)).to be_empty
        expect { get :index, event_id: event.id  }.to change { member.shopping_carts.count }.by(1)
      end

      it "finds an existing shopping cart" do
        member.shopping_carts << FactoryGirl.create(:shopping_cart, event: event, member: member)
        expect { get :index, event_id: event.id  }.to change { member.shopping_carts.count }.by(0)
      end
    end

    context "new cart item saved" do
      it "creates a new cart item" do
        expect do
          post :add_to_cart, event_id: event.id, product_id: product.id
        end.to change(CartItem, :count).from(0).to(1)
      end

      it "adds new cart item to shopping cart" do
        member_cart = FactoryGirl.create(:shopping_cart, event: event, member: member)
        post :add_to_cart, event_id: event.id, product_id: product.id
        expect(member_cart.cart_items).to include(CartItem.last)
      end

      it "redirects to event inventories path" do
        post :add_to_cart, event_id: event.id, product_id: product.id
        expect(response).to redirect_to(event_products_path(event: event))
      end

      it "displays correct notice" do
        post :add_to_cart, event_id: event.id, product_id: product.id
        expect(flash[:notice]).to eq("Item added to cart")
      end
    end

    ### this shouldn't be a possibility...
    context "new cart item cannot be saved" do
    end
  end

  describe "#edit" do
    let(:editable_product) { FactoryGirl.create(:product, event_id: event.id) }

    before do
      get :edit, event_id: event.id, id: editable_product.id
    end

    render_views

    it "returns a view" do
      expect(response).to render_template(:edit)
    end

    it "returns http success" do
      expect(response).to be_ok
      expect(response).to have_http_status(:success)
    end

    it "finds the correct product to edit" do
      expect(assigns(:product)).to eql(editable_product)
    end
  end

  describe "#update" do
    let!(:original_vendor) { FactoryGirl.create(:vendor) }
    let!(:updated_vendor) { FactoryGirl.create(:vendor) }
    let!(:product) { FactoryGirl.create(:product, name: "Choco Taco", price_cents: 100, unit_type: "each", vendor_id: original_vendor.id, event: event) }
    let!(:updated_params) { attributes_for(:product, name: "Twinkie", price_cents: 400, unit_type: "bag", vendor_id: updated_vendor.id, event: event) }

    context "name" do
      it "updates the name" do
        product.name = updated_params[:name]
        put :update, event_id: event.id, id: product.id, product: product.attributes
        expect(Product.find(product.id).name).to eq(updated_params[:name])
      end

      xit "displays product in correct order (alphabetically)" do
        a_product = FactoryGirl.create(:product, name: "Alligator")
        h_product = FactoryGirl.create(:product, name: "Hippo")
        z_product = FactoryGirl.create(:product, name: "Zebra")
        # products = [a_product, h_product, z_product, product]
        expect(event.products).to eq([a_product, product, h_product, z_product])

        product.name = updated_params[:name]
        put :update, event_id: event.id, id: product.id, product: product.attributes
        expect(event.products).to eq([a_product, h_product, product, z_product])
      end
    end

    it "updates the price" do
      product.price_cents = updated_params[:price_cents]
      put :update, event_id: event.id, id: product.id, product: product.attributes
      expect(Product.find(product.id).price_cents).to eq(updated_params[:price_cents])
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
