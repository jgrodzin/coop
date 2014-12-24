require "rails_helper"

describe "Event" do
  let!(:member) { FactoryGirl.create :member }
  let!(:admin) { FactoryGirl.create(:member, admin: true) }

  describe "member" do
    before do
      login_as member, scope: :member
    end

    it "cannot create a new event" do
      visit events_path
      expect(page).to_not have_link("New event")
    end
  end

  describe "admin" do
    before { login_as admin, scope: :member }
    let!(:events) { FactoryGirl.create_list(:event, 10) }

    it "can create a new event" do
      visit events_path
      click_link "New event"
      expect(page).to have_css("form")
    end
  end
end
