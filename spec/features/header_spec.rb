require "rails_helper"

describe "Menu" do
  context "not logged in" do
    it "renders login form" do
      visit root_path
      expect(page).to have_css(".sign-in-form")
    end
  end

  context "logged in as admin" do
    let(:admin) { FactoryGirl.create(:member, admin: true) }

    before do
      login_as admin, scope: :member
    end

    it "displays admin menu item" do
      visit root_path
      expect(page).to have_css("a[href=\"#{root_path}\"]")
      expect(page).to have_css("a[href=\"#{admins_path}\"]")
    end
  end

  context "logged in as member" do
    let(:member) { FactoryGirl.create(:member) }

    before do
      login_as member, scope: :member
    end

    it "does not display admin in menu" do
      visit root_path
      save_and_open_page
      expect(page).to_not have_css("a[href=\"#{admins_path}\"]")
    end
  end
end
