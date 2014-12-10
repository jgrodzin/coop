require "rails_helper"

describe CartItemsController, type: :controller do
  let!(:member) { FactoryGirl.create(:member) }
  let!(:event) { FactoryGirl.create(:event) }
  let!(:shopping_cart) { FactoryGirl.create(:shopping_cart, member: member, event: event) }

  before do
    sign_in member
  end

  describe "#index" do
    before do
      get :index, event_id: event.id, shopping_cart_id: shopping_cart.id
    end

    it "returns the member's shopping cart for event" do
      expect(assigns(:shopping_cart)).to eq(shopping_cart)
    end

    context "with cart items" do
      let!(:cart_item_z) { FactoryGirl.create(:cart_item, shopping_cart: shopping_cart, product: FactoryGirl.create(:product, name: "Zuccini", event: event)) }
      let!(:cart_item_a) { FactoryGirl.create(:cart_item, shopping_cart: shopping_cart, product: FactoryGirl.create(:product, name: "Asparagus", event: event)) }
      let!(:cart_item_p) { FactoryGirl.create(:cart_item, shopping_cart: shopping_cart, product: FactoryGirl.create(:product, name: "Pasta", event: event)) }

      it "orders cart items alphabetically by name" do
        expect(assigns(:sorted_cart_items)).to eq([cart_item_a, cart_item_p, cart_item_z])
      end
    end
  end

  describe "#edit" do
    let!(:item_to_be_edited) { FactoryGirl.create(:cart_item) }

    before do
      get :edit, event_id: event.id, shopping_cart_id: shopping_cart.id, id: item_to_be_edited.id
    end

    render_views

    it "returns a view" do
      expect(response).to render_template(:edit)
    end

    it "returns http success" do
      expect(response).to be_ok
      expect(response).to have_http_status(:success)
    end

    it "finds the correct item to be edited" do
      expect(assigns(:cart_item)).to eq(item_to_be_edited)
    end
  end

  describe "#update" do
    it "updates a cart item's amount" do
      cart_item = FactoryGirl.create(:cart_item, amount: 1)
      cart_item.amount = 5
      put :update, event_id: event.id, shopping_cart_id: shopping_cart.id, id: cart_item.id, cart_item: cart_item.attributes
      expect(CartItem.find(cart_item.id).amount).to eq(5)
    end
  end

  describe "#destroy" do
    let!(:cart_items) { FactoryGirl.create_list(:cart_item, 10, shopping_cart: shopping_cart) }
    let!(:item_to_be_destroyed) { cart_items.first }

    it "deletes a cart item" do
      expect do
        delete :destroy, event_id: event.id, shopping_cart_id: shopping_cart.id, id: item_to_be_destroyed.id
      end.to change { shopping_cart.cart_items.count }.from(10).to(9)
    end
  end
end
