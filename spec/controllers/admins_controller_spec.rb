require "rails_helper"

describe AdminsController, type: :controller do
  let!(:member) { FactoryGirl.create(:member) }
  let!(:admin) { FactoryGirl.create(:member, admin: true) }

  before do
    sign_in admin
  end

  describe "#index" do
    it "shows the admin dashboard" do
      get :index
      expect(response).to render_template(:index)
    end

    it "denies access to non-admin members" do
      sign_in member
      get :index
      expect(response).to redirect_to root_url
    end
  end
end
