require "rails_helper"

describe ProductsController, type: :controller do
  let(:member) { FactoryGirl.create(:member) }

  describe "index" do

    before do
      sign_in member
    end

    it "finds all products and groups by vendor" do
      products = FactoryGirl.create_list(:product, 10)
      get :index
      expect(assigns(:products)).to eq(products.group_by(&:vendor))
    end
  end
end
