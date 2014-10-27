require "rails_helper"

describe Event do
	context "assocations" do
		it { should have_many :inventories }
		it { should have_many(:involved_vendors).through(:inventories)}
		it { should belong_to :team }
	end
end
