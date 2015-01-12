require "rails_helper"

describe Product do
  context "associations" do
    it { should belong_to :vendor }
    it { should have_many :cart_items }
    it { should belong_to :event }
  end

  context "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :vendor_id }
    it { should validate_presence_of :event_id }
  end

  it { should monetize :price_cents }

  describe "#total_inventory_price" do
    it "should return total price of product in inventory" do
      product_1 = create(:product, price: 10, total_amount_purchased: 10)
      product_2 = create(:product, price: 5, total_amount_purchased: 10)

      expect(product_1.total_inventory_price).to eq(100)
      expect(product_2.total_inventory_price).to eq(50)
    end
  end
end
