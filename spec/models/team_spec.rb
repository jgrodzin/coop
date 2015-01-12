require "rails_helper"

describe Team do
  context "assocations" do
    it { should have_many :members }
    it { should have_many(:leaders).through(:team_lead_members) }
    it { should have_many :team_lead_members }
    it { should have_many :team_members }
    it { should have_many :events }

    context "#validations" do
      # it { should validate_presence_of :members }"
    end

    describe "#team_lead_members" do
      let(:team) { FactoryGirl.create(:team) }
      let(:member_1) { FactoryGirl.create(:member) }
      let(:member_2) { FactoryGirl.create(:member) }
      let!(:team_leader_1) { FactoryGirl.create(:team_member, member: member_1, team: team, leader: true) }
      let!(:team_leader_2) { FactoryGirl.create(:team_member, member: member_2, team: team, leader: false) }

      it "only returns team_members that are leaders" do
        expect(team.team_lead_members).to eq([team_leader_1])
      end
    end
  end

  context do
    let(:team) { FactoryGirl.create(:team) }
    let(:member_1) { FactoryGirl.create(:member) }
    let(:member_2) { FactoryGirl.create(:member) }
    let!(:team_leader_1) { FactoryGirl.create(:team_member, member: member_1, team: team, leader: true) }
    let!(:team_leader_2) { FactoryGirl.create(:team_member, member: member_2, team: team, leader: true) }

    describe "#leader_names" do
      it "returns all leaders names" do
        expect(team.leader_names).to eq("#{team_leader_1.member.name}, #{team_leader_2.member.name}")
      end
    end

    describe "#team_member_names" do
      it "returns all first names of team members" do
        expect(team.team_member_names).to eq("#{member_1.first_name}, #{member_2.first_name}")
      end
    end
  end
end
