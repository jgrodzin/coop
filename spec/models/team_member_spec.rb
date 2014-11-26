require "rails_helper"

describe TeamMember do
  context "assocations" do
    it { should belong_to :member }
    it { should belong_to :team }
  end

  context "validations" do
    it { should validate_presence_of :team_id }
    it { should validate_presence_of :member_id }
  end
end
