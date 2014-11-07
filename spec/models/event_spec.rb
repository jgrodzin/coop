require "rails_helper"

describe Event do
  context "assocations" do
    it { should have_many :inventory }
    it { should have_many(:involved_vendors).through(:inventory) }
    it { should belong_to :team }
  end
end
