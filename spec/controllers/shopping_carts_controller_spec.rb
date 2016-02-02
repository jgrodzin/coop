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
      post :add_to_cart, event_id: event.id, product_id: product.id, cart_item: { amount: 1 }
      expect(assigns(:cart_item)).to be_kind_of(CartItem)
    end

    describe "sets shopping cart" do
      it "creates a shopping cart if one does not exist" do
        expect(member.shopping_carts.where(event_id: event.id)).to be_empty
        expect { get :index, event_id: event.id }.to change { member.shopping_carts.count }.by(1)
      end

      it "finds an existing shopping cart" do
        member.shopping_carts << FactoryGirl.create(:shopping_cart, event: event, member: member)
        expect { get :index, event_id: event.id }.to change { member.shopping_carts.count }.by(0)
      end
    end

    context "new cart item saved" do
      it "creates a new cart item" do
        expect do
          post :add_to_cart, event_id: event.id, product_id: product.id, cart_item: { amount: 1 }
        end.to change(CartItem, :count).by(1)
      end

      it "adds new cart item to shopping cart" do
        member_cart = FactoryGirl.create(:shopping_cart, event: event, member: member)
        post :add_to_cart, event_id: event.id, product_id: product.id, cart_item: { amount: 1 }
        expect(member_cart.cart_items).to include(CartItem.last)
      end
    end
  end

  describe "show" do
    let!(:member_shopping_cart) { create(:shopping_cart, member: member) }
    let(:other_shopping_cart) { create(:shopping_cart) }

    context "admin" do
      let!(:admin_shopping_cart) { create(:shopping_cart, member: admin) }
      let(:admin) { create(:admin) }

      before do
        sign_in admin
      end

      it "can view all price sheets" do
        get :show, id: member_shopping_cart.id
        expect(response).to render_template(:show)
      end
    end

    context "members" do
      before do
        sign_in member
      end

      it "can view personal price sheet" do
        get :show, id: member_shopping_cart.id
        expect(response).to render_template(:show)
      end

      it "cannot view other price sheets" do
        get :show, id: other_shopping_cart.id
        expect(response).to redirect_to root_url
      end
    end

    context "substitutes" do
      let(:sub) { create(:member, status: "substitute") }
      let!(:sub_shopping_cart) { create(:shopping_cart, member: sub) }

      before do
        sign_in sub
      end

      it "can view personal price sheet" do
        get :show, id: sub_shopping_cart.id
        expect(response).to render_template(:show)
      end

      it "cannot view other price sheets" do
        get :show, id: other_shopping_cart.id
        expect(response).to redirect_to root_url
      end
    end
  end
end
