require "rails_helper"

describe VendorsController, type: :controller do
  let(:member) { FactoryGirl.create(:member) }

  before do
    sign_in member
  end

  describe "index" do
    before { get :index }

    it "returns all vendors" do
      expect(assigns(:vendors)).to eq(Vendor.all)
    end

    context "views" do
      render_views
      it "renders the view" do
        expect(response).to render_template(:index)
      end
    end
  end

  describe "show" do
    let(:test_vendor) { FactoryGirl.create(:vendor, :with_products)  }
    before { get :show, id: test_vendor.id }
    render_views

    it "finds the products belonging to the vendor" do
      expect(assigns(:vendor).products).to eq(test_vendor.products)
    end

    it "renders a view" do
      expect(response).to render_template(:show)
    end
  end
end
