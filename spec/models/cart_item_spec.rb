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
end
