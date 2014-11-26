require "rails_helper"

describe CartItem do
  context "associations" do
    it { should belong_to :shopping_cart }
    it { should belong_to :product }
  end

  it "is put into a user's shopping cart" do
    member = FactoryGirl.create(:member)
    shopping_cart = FactoryGirl.create(:shopping_cart, member: member)
    product = FactoryGirl.create(:product, name: "Choco Taco")
    # cart_item = FactoryGirl.create(:cart_item)
    binding.pry
    shopping_cart.add_item(product)
    expect(shopping_cart.cart_items.map(&:product)).to include(product)
  end
end
