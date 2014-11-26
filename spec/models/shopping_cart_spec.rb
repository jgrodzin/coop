require "rails_helper"

describe ShoppingCart do
  context "association" do
    it { should belong_to :event }
    it { should belong_to :member }
    it { should have_many(:items).through(:event) }
  end

  context "validations" do
    it { should validate_presence_of :member_id }
    it { should validate_presence_of :event_id }
  end
end
