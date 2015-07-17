require "rails_helper"

describe "Team" do
  let!(:member) { FactoryGirl.create :member }
  let!(:admin) { FactoryGirl.create :admin }

  describe "member" do
    before do
      login_as member, scope: :member
    end

    it "cannot create a new team" do
      visit teams_admins_path
      expect(page).to_not have_link("Create new team")
    end
  end

  describe "admin" do
    before { login_as admin, scope: :member }

    context "#create" do
      let!(:possible_team_members) { create_list(:member, 10) }

      it "can create a new team" do
        visit teams_admins_path
        click_link "+ Add Team"
        expect(page).to have_css("form")
      end

      xit "automatically sets leader as a team member if not specified" do
        team_leader = possible_team_members.first
        visit teams_admins_path
        click_link "Create new team"
        check("team_leader_ids_#{team_leader.id}")
        click_button "Save"

        expect(Team.count).to eq(1)
        expect(Team.first.leaders.first).to eq(Member.first)
        expect(Team.first.members).to include(Member.first)
      end

      xit "can assign multiple leaders to a team" do
        team_leader_1 = Member.first
        team_leader_2 = Member.second
        visit teams_admins_path
        click_link "Create new team"
        check("team_leader_ids_#{team_leader_1.id}")
        check("team_leader_ids_#{team_leader_2.id}")
        click_button "Save"

        expect(Team.count).to eq(1)
        expect(Team.first.leaders).to match_array([team_leader_1, team_leader_2])
        expect(Team.first.members).to include(team_leader_1, team_leader_2)
      end
    end
  end
end
