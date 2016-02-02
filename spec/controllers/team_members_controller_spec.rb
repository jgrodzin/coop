require "rails_helper"

describe TeamMembersController, type: :controller do
  let!(:admin) { FactoryGirl.create(:admin) }

  before do
    sign_in admin
  end

  describe "#destroy" do
    it "should remove the correct team member" do
      members = FactoryGirl.create_list(:member, 3)
      team = FactoryGirl.create(:team)
      team_members = members.each do |member|
        FactoryGirl.create(:team_member, team_id: team.id, member_id: member.id)
      end

      # expect do
      #   delete :destroy, id: team_members.first
      # end.to change(TeamMember, :count).from(3).to(2)
    end
  end
end
