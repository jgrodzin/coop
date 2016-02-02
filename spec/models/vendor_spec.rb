require "rails_helper"

describe Vendor do
  context "assocations" do
    it { should have_many :products }
  end

  context "validations" do
    it { should validate_presence_of :name }
  end
end
