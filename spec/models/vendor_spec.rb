require "rails_helper"

describe Vendor do
  context "assocations" do
  	it { should have_many :products }
  	# it { should belong_to(:event).through(:event_prodcuts) }
  end

  context "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :rep }
  end
end
