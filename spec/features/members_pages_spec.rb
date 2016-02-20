require "rails_helper"

describe "Members", type: :feature do
  let(:admin) { FactoryGirl.create(:admin) }
  let(:member) { create(:member, admin: false) }

  describe "edit page" do
    context "as an admin" do
      before { login_as admin, scope: :member }

      it "has an admin checkbox" do
        visit member_path(member)
        have_selector("input[value='#{member.first_name}']")
        have_selector("input[type='checkbox'] name='member[admin]'")
      end
    end

    context "as a non admin" do
      before { login_as member, scope: :member }

      it "has an admin checkbox" do
        visit member_edit_account_path(member)
        have_selector("input[value='#{member.first_name}']")
        expect(page).to_not have_text(/Admin/i)
      end
    end
  end
end
