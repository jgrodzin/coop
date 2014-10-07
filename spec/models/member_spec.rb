require "rails_helper"

describe Member do
  context "associations" do
    it { should have_many :team_members }
    it { should have_many(:teams).through(:team_members) }
  end

  context "roles" do
    it "can be an admin user"
    it "can be a team member"
    it "can be a leader of a team"
  end
end
