require "rails_helper"

describe CartItem do
  context "associations" do
    it { should belong_to :shopping_cart }
    it { should belong_to :product }
  end

  context "validations" do
    it { should validate_presence_of :product }
    it { should validate_presence_of :shopping_cart }
    # it { should validate_numericality_of :amount }
  end

  it "#add_item" do
    member = FactoryGirl.create(:member)
    shopping_cart = FactoryGirl.create(:shopping_cart, member: member)
    product = FactoryGirl.create(:product, name: "Choco Taco")

    shopping_cart.add_item(product)
    expect(shopping_cart.cart_items.map(&:product)).to include(product)
  end
end
