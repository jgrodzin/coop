require "rails_helper"

describe "Product page" do
  let(:member) { FactoryGirl.create :member }

  before do
    login_as member
  end

  describe "index" do
    before { visit products_path }

    product = FactoryGirl.create(:product)

    it "should display link to vendor" do
      expect(page).to have_css("a", text: "#{product.vendor.name}")
    end
  end
end
