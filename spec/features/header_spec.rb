require "rails_helper"

describe "Menu" do
  context "not logged in" do
    it "renders login form" do
      visit root_path
      expect(page).to have_css(".sign-in-form")
    end
  end

  context "logged in as admin" do
    let(:admin) { FactoryGirl.create(:admin) }

    before do
      login_as admin, scope: :member
    end

    it "displays dashboard" do
      visit root_path
      expect(page).to have_css("a[href=\"#{root_path}\"]")
      expect(page).to have_css("a[href=\"#{my_account_path}\"]")
    end
  end

  context "logged in as member" do
    let(:member) { FactoryGirl.create(:member) }

    before do
      login_as member, scope: :member
    end

    it "displays dashboards#index" do
      visit root_path
      expect(page).to have_css("a[href=\"#{my_account_path}\"]")
    end
  end
end
