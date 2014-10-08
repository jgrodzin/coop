require "rails_helper"

describe Event do
	context "assocations" do
		it { should have_many :event_products }
		it { should have_many(:involved_vendors).through(:event_products)}
		it { should belong_to :team }
	end
end
