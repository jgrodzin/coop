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

  # describe "Member's actions" do
  #   it "memeber can add item to their cart" do
  #     member = FactoryGirl.create(:member)
  #     event = FactoryGirl.create(:event)
  #     cart = FactoryGirl.create(:shopping_cart, member: member, event: event)
  #   end

  #   it "member can remove item"
  #   it "memeber can update item info"
  # end

  # describe "Instantiation" do
  #   it "is active during an event"
  #   it "is not active outside of event time"
  # end

  # describe "Cart Actions" do
  #   it "calculates the cart total"
  #   it "calculates an items total"
  #   it "saves current cart items"
  # end
end
