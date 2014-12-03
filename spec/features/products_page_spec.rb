require "rails_helper"

describe "Product page" do
  describe "index" do

    it "should display link to vendor" do
      expect(page).to have_css("a", text: "#{subject.vendor.name}")
    end
  end
end
