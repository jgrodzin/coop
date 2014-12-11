require "rails_helper"

describe Team do
  context "assocations" do
    it { should have_many :members }
    # it { should have_many :leaders }
    it { should have_many :team_members }
    it { should have_many :events }
  end

  context do
    let(:team) { FactoryGirl.create(:team) }
    let(:member_1) { FactoryGirl.create(:member) }
    let(:member_2) { FactoryGirl.create(:member) }
    let!(:team_leader_1) { FactoryGirl.create(:team_member, member: member_1, team: team, leader: true) }
    let!(:team_leader_2) { FactoryGirl.create(:team_member, member: member_2, team: team, leader: true) }

    describe "#leaders" do
      it "returns all members with leader status" do
        expect(team.leaders).to eq([team_leader_1, team_leader_2])
      end
    end

    describe "#leader_names" do
      it "returns all leaders names" do
        expect(team.leader_names).to eq("#{team_leader_1.member.name}, #{team_leader_2.member.name}")
      end
    end
  end
end
