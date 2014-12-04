require "rails_helper"

describe ShoppingCart do
  context "association" do
    it { should belong_to :event }
    it { should belong_to :member }
    it { should have_many :cart_items }
  end

  context "validations" do
    it { should validate_presence_of :member_id }
    it { should validate_presence_of :event_id }
  end

  context "cart actions" do
    # describe "#calculate_sub_total" do
    #   it "calculates sub total of all items in cart" do
    #     member = FactoryGirl.create(:member)
    #     shopping_cart = FactoryGirl.create(:shopping_cart, member: member)
    #     product_1 = FactoryGirl.create(:product, name: "Choco Taco", price: 10)
    #     product_2 = FactoryGirl.create(:product, name: "Push pop", price: 20)

    #     shopping_cart.cart_items << FactoryGirl.create(:cart_item, product: product_1, amount: 1)
    #     shopping_cart.cart_items << FactoryGirl.create(:cart_item, product: product_2, amount: 1)

    #     expect(shopping_cart.calculate_sub_total).to eq(30.0)
    #   end
    # end
  end
end
