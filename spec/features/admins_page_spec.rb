require "rails_helper"

describe "Admin" do
  let(:admin) { FactoryGirl.create(:member, admin: true) }

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

    describe "dashboard / index" do

      it "has links to each app feature" do
        links = [
          members_path,
          new_member_path,
          teams_admins_path,
          events_path,
          new_event_path,
          vendors_path,
          new_vendor_path,
          products_admins_path
        ]

        visit admins_path

        links.each do |link|
          expect(page).to have_css("a[href=\"#{link}\"]")
        end
      end
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
