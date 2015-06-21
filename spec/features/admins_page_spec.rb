require "rails_helper"

describe "Admin" do
  let(:admin) { FactoryGirl.create(:admin) }

  context "not logged in" do
    it "renders login form" do
      visit root_path
      expect(page).to have_css(".sign-in-form")
    end
  end

  context "logged in" do
    before do
      login_as admin, scope: :member
    end

    describe "teams page" do
      it "has an edit button for each team" do
        teams = FactoryGirl.create_list(:team, 4)
        visit teams_admins_path
        teams.each do |team|
          expect(page).to have_css("a[href=\"#{edit_team_path(team)}\"]")
        end
      end
    end
  end
end
