require "rails_helper"

describe PriceSheet do
  context "association" do
    it { should belong_to :member }
    it { should belong_to :event }
    it { should have_many(:products).through(:event) }
  end
end
