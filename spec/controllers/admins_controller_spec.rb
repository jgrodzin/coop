require "rails_helper"

describe AdminsController, type: :controller do
  let!(:member) { FactoryGirl.create(:member) }
  let!(:admin) { FactoryGirl.create(:admin) }

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

  describe "#products" do
    it "displays all products" do
      FactoryGirl.create_list(:product, 10)
      get :products
      expect(assigns(:products)).to eq(Product.all.includes(:vendor).group_by(&:vendor))
    end
  end

  describe "#teams" do
    it "allows admin access to edit all teams" do
      FactoryGirl.create_list(:team, 4)
      get :teams
      expect(assigns(:teams)).to eq(Team.all.includes(:team_members))
    end
  end
end
