require "rails_helper"

describe TeamMember do
  context "assocations" do
    it { should belong_to :member }
    it { should belong_to :team }
  end
end
