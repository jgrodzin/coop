require "rails_helper"

describe CartItem do
  context "associations" do
    it { should belong_to :shopping_cart }
    it { should belong_to :product }
  end

  context "validations" do
    it { should validate_presence_of :product }
    it { should validate_presence_of :shopping_cart }
    it { should validate_numericality_of :amount }
    it { should validate_uniqueness_of(:product_id) }
  end

  context "initialization" do
    it "default amount should be 1" do
      new_cart_item = FactoryGirl.create(:cart_item)
      expect(new_cart_item.amount).to eq(1)
    end
  end

  describe "#calculate_sub_total_price" do
    it "calculates the total of a cart item based on amount specified" do
      product = FactoryGirl.create(:product, name: "Salami", price: 5)
      cart_item = FactoryGirl.create(:cart_item, product: product, amount: 3)

      expect(cart_item.calculate_sub_total_price).to eq(15)
    end
  end
end
