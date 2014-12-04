require "rails_helper"

describe "Product page" do
  let(:member) { FactoryGirl.create :member }

  before do
    login_as member
  end

  describe "index" do
    before { visit event_shopping_cart_cart_items_path }
  end
end
