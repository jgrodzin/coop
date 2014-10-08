require "rails_helper"

describe Vendor do
	context "assocations" do
		 it { should have_many :products }
		 # it { should belong_to(:event).through(:event_prodcuts) }
	end
end
