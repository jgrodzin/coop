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
      let!(:cart_item_z) { FactoryGirl.create(:cart_item, shopping_cart: shopping_cart, product: FactoryGirl.create(:product, name: "Zuccini")) }
      let!(:cart_item_a) { FactoryGirl.create(:cart_item, shopping_cart: shopping_cart, product: FactoryGirl.create(:product, name: "Asparagus")) }
      let!(:cart_item_p) { FactoryGirl.create(:cart_item, shopping_cart: shopping_cart, product: FactoryGirl.create(:product, name: "Pasta")) }
      let!(:ordered_cart_items) { [cart_item_a, cart_item_p, cart_item_z] }

      it "should always order cart items by name" do
        expect(assigns(:shopping_cart_items)).to eq(ordered_cart_items)
      end

      context "views" do
        render_views

        it "displays each cart item" do
          # assert_select "form", ordered_cart_items.count
        end
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
  end

  describe "#update" do
    it "updates a cart item's amount"
  end

  describe "#destroy" do
    let!(:cart_items) { FactoryGirl.create_list(:cart_item, 10, shopping_cart: shopping_cart) }
    let!(:item_to_be_destroyed) { cart_items.first }

    it "deletes a cart item" do
      expect { delete :destroy, event_id: event.id, shopping_cart_id: shopping_cart.id, id: item_to_be_destroyed.id }.to change { shopping_cart.cart_items.count }.by(-1)
    end
  end
end
