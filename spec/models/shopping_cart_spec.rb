require "rails_helper"

describe ShoppingCart do
  context "association" do
    it { should belong_to :member }
    it { should belong_to :event }
    it { should have_many(:items).through(:event) }
  end
end
