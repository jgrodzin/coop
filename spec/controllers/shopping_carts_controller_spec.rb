require "rails_helper"

describe ShoppingCartsController, type: :controller do
  let!(:member) { FactoryGirl.create(:member) }
  let!(:event) { FactoryGirl.create(:event) }

  before do
    sign_in member
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
        expect(response).to redirect_to(event_shopping_carts_path(event: event))
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
end
