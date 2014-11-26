require "rails_helper"

describe Inventory do
  context "assocations" do
    it { should belong_to :event }
    it { should belong_to :product }
  end
end
