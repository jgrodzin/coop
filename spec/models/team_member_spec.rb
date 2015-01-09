require "rails_helper"

describe TeamMember do
  context "assocations" do
    it { should belong_to :member }
    it { should belong_to :team }
  end

  context "validations" do
    it { should validate_presence_of :team_id }
    it { should validate_presence_of :member_id }
    it { should validate_uniqueness_of(:team_id).scoped_to(:member_id).with_message("Member is already on this team") }

    context "member_id and team_id" do
      let!(:team) { create(:team) }
      let!(:member) { create(:member) }
      let!(:team_member) { create(:team_member, member_id: member.id, team_id: team.id) }

      it "is valid when it has a unique combination" do
        expect(team_member).to be_valid
      end

      it "is invalid when it has an already taken combination" do
        duplicate_team_member = build(:team_member, member_id: member.id, team_id: team.id)
        expect(duplicate_team_member).to_not be_valid
      end

      it "is valid when member is assigned to different teams" do
        team_2 = create(:team)
        team_member_2 = create(:team_member, member: member, team: team_2)
        expect(team_member_2).to be_valid
      end
    end
  end
end
