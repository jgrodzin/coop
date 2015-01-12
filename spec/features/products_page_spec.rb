require "rails_helper"

describe "Product" do
  describe "Setting up event inventory" do
    let!(:member_1) { FactoryGirl.create :member }
    let!(:member_2) { create(:member) }
    let!(:team_1) { create(:team) }
    let!(:team_2) { create(:team) }
    let!(:team_member) { create(:team_member, team: team_1, member: member_1) }
    let!(:non_team_member) { create(:team_member, team: team_2, member: member_2) }
    let!(:event) { create(:event, team: team_1) }

    context "Member is on event's team" do
      before do
        login_as member_1, scope: :member
      end

      it "should be able to add products" do
        visit event_products_path(event)
        expect(page).to have_css("form")
      end
    end

    context "Member is not on event's team" do
      before do
        login_as member_2, scope: :member
      end

      it "should not be able to add products" do
        visit event_products_path(event)
        expect(page).to_not have_css("form")
      end
    end
  end
end
