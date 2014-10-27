require "rails_helper"

describe Team do
	context "assocations" do
    it { should have_many :members }
	  it { should have_many :leaders }
	  it { should have_many :events }
	end
end
