require "rails_helper"

describe "Cart Item / my shopping cart page" do
  let!(:member) { FactoryGirl.create :member }
  let!(:event) { FactoryGirl.create :event }
  let!(:shopping_cart) { FactoryGirl.create(:shopping_cart, member: member, event: event) }

  before do
    login_as member, scope: :member
  end

  describe "index" do
    it "updates cart item price if the team alters the price of the product in the event" do
      product = FactoryGirl.create(:product, price: Money.new(1))
      cart_item = shopping_cart.cart_items.build(product: product)
      cart_item.save
      visit event_shopping_cart_cart_items_path(event_id: event.id, shopping_cart_id: shopping_cart.id)
      expect(page).to have_text(product.price)

      product.update(price: Money.new(5))
      visit event_shopping_cart_cart_items_path(event_id: event.id, shopping_cart_id: shopping_cart.id)
      expect(page).to have_text(product.price)
    end
  end
end
