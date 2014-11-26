require "rails_helper"

describe Product do
  context "associations" do
    it { should belong_to :vendor }
  end

  context "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :vendor_id }
  end

  it { should monetize :price_cents }
end
