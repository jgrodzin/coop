require "rails_helper"

describe InventoriesController, type: :controller do
  # include MoneyRails::ActionViewExtension

  let(:member) { FactoryGirl.create(:member) }
  let(:event) { FactoryGirl.create(:event) }
  let(:non_event_products) { FactoryGirl.create_list(:product, 10) }

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
      get :index, event_id: event.id

      non_event_products.each do |product|
        event.inventories << FactoryGirl.create(:inventory, product: product)
      end

      expect(event.products).to eq(non_event_products)
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

    it "builds a new inventory object" do
      expect(assigns(:inventory)).to be_kind_of(Inventory)
    end

    it "builds a new product object" do
      expect(assigns(:product)).to be_kind_of(Product)
    end
  end

  describe "#create" do
    let(:vendor) { FactoryGirl.create(:vendor) }

    context "with valid params" do

      let(:inventory_create_params) do
        {
          product: attributes_for(:product, vendor_id: vendor.id),
          event_id: event.id
        }
      end

      it "creates a product" do
        expect { post :create, inventory_create_params }.to change { Product.count }.by(1)
      end

      it "creates an inventory object containing the product" do
        expect { post :create, inventory_create_params }.to change { Inventory.count }.by(1)
        new_product = assigns(:product)
        expect(Inventory.last.product).to eq(new_product)
      end

      it "associates the correct event with the new inventory item" do
        post :create, inventory_create_params
        expect(event.inventories.last).to eq(Inventory.last)
      end

      it "redirects to event inventories path" do
        post :create, inventory_create_params
        expect(response).to redirect_to(event_inventories_path)
      end

      it "sets the notice message appropriately" do
        post :create, inventory_create_params
        expect(flash[:notice]).to eq("Product successfully added")
      end
    end

    context "invalid params" do
      let(:invalid_inventory_params) do
        {
          product: attributes_for(:product),
          event_id: event.id
        }
      end

      it "re-renders the new form if the product is not persisted" do
        expect { post :create, invalid_inventory_params }.to change { Inventory.count }.by(0)
        expect(response).to render_template(:new)
      end
    end
  end

  describe "#add_to_cart" do
    let(:product) { FactoryGirl.create(:product) }
    let(:inventory) { FactoryGirl.create(:inventory, event: event, product: product) }

    it "builds a new cart item for shopping cart" do
      post :add_to_cart, event_id: event.id, product_id: inventory.product.id
      expect(assigns(:cart_item)).to be_kind_of(CartItem)
    end

    ### repeated in index
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
        expect { post :add_to_cart, event_id: event.id, product_id: inventory.product.id }.to change { CartItem.count }.by(1)
      end

      it "adds new cart item to shopping cart" do
        member_cart = FactoryGirl.create(:shopping_cart, event: event, member: member)
        post :add_to_cart, event_id: event.id, product_id: inventory.product.id
        expect(member_cart.cart_items).to include(CartItem.last)
      end

      it "redirects to event inventories path" do
        post :add_to_cart, event_id: event.id, product_id: inventory.product.id
        expect(response).to redirect_to(event_inventories_path(event: event))
      end

      it "displays correct notice" do
        post :add_to_cart, event_id: event.id, product_id: inventory.product.id
        expect(flash[:notice]).to eq("Item added to cart")
      end
    end

    ### this shouldn't be a possibility...
    context "new cart item cannot be saved" do
    end
  end

  describe "#edit" do
    let(:editable_product) { FactoryGirl.create(:product) }

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
  end

  describe "#update" do
    let!(:original_vendor) { FactoryGirl.create(:vendor) }
    let!(:updated_vendor) { FactoryGirl.create(:vendor) }
    let!(:updateable_product) { FactoryGirl.create(:product, name: "Choco Taco", price: Money.new(100), unit_type: "each", vendor_id: original_vendor.id) }
    let!(:updated_params) { attributes_for(:product, name: "Twinkie", price: Money.new(900), unit_type: "bag", vendor_id: updated_vendor.id) }

    it "updates the name" do
      updateable_product.name = updated_params[:name]
      put :update, event_id: event.id, id: updateable_product.id, product: updateable_product.attributes
      expect(Product.find(updateable_product.id).name).to eq(updated_params[:name])
    end

    it "updates the price" do
      updateable_product.price = updated_params[:price]
      put :update, event_id: event.id, id: updateable_product.id, product: updateable_product.attributes
      expect(Product.find(updateable_product.id).price).to eq(updated_params[:price])
    end

    it "updates the unit type" do
      updateable_product.unit_type = updated_params[:unit_type]
      put :update, event_id: event.id, id: updateable_product.id, product: updateable_product.attributes
      expect(Product.find(updateable_product.id).unit_type).to eq(updated_params[:unit_type])
    end

    it "updates the vendor..." do
      updateable_product.vendor_id = updated_params[:vendor_id]
      put :update, event_id: event.id, id: updateable_product.id, product: updateable_product.attributes
      expect(Product.find(updateable_product.id).vendor_id).to eq(updated_params[:vendor_id])
    end
  end

  describe "#destroy" do
    let!(:product) { FactoryGirl.create(:product) }
    let!(:destroyable_inventory) { FactoryGirl.create(:inventory, event: event, product: product) }

    it "removes product from inventory" do
      expect { delete :destroy, event_id: event.id, id: destroyable_inventory.id }.to change { Inventory.count }.by(-1)
    end

    it "does not destroy the product" do
      expect { delete :destroy, event_id: event.id, id: destroyable_inventory.id }.to change { Product.count }.by(0)
    end
  end
end
