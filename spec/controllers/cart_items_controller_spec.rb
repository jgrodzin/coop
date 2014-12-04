require "rails_helper"

describe CartItemsController, type: :controller do
  let(:member) { FactoryGirl.create(:member) }

  before do
    sign_in member
  end

  describe "#index" do
    let!(:event) { FactoryGirl.create(:event) }
    let!(:shopping_cart) { FactoryGirl.create(:shopping_cart, member: member, event: event) }

    before do
      get :index, event_id: event.id, shopping_cart_id: shopping_cart.id
    end

    it "returns the member's shopping cart for event" do
      expect(assigns(:shopping_cart)).to eq(shopping_cart)
    end

    # where am I error handling this page? should this be an integration test?
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
          assert_select "body"
        end
      end
    end

  end
end
