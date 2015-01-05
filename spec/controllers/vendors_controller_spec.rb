require "rails_helper"

describe VendorsController, type: :controller do
  let(:member) { FactoryGirl.create(:member) }

  before do
    sign_in member
  end

  describe "#index" do
    before { get :index }

    it "returns all vendors" do
      expect(assigns(:vendors)).to match_array(Vendor.all)
    end

    context "views" do
      render_views
      it "renders the view" do
        expect(response).to render_template(:index)
      end
    end
  end

  describe "#show" do
    let(:test_vendor) { FactoryGirl.create(:vendor, :with_products)  }

    before do
      get :show, id: test_vendor.id
    end

    render_views

    it "finds the products belonging to the vendor" do
      expect(assigns(:vendor).products).to eq(test_vendor.products)
    end

    it "renders a view" do
      expect(response).to render_template(:show)
    end
  end

  describe "#new" do
    before { get :new }

    it "builds a new vendor object" do
      expect(assigns(:vendor)).to be_kind_of(Vendor)
      expect(assigns(:vendor)).to_not be_persisted
    end

    it "returns an http success" do
      expect(response).to have_http_status(:success)
    end
  end

  describe "#create" do
    context "with valid params" do
      def valid_vendor_params
        {
          name: "How Now Brown Cow Meats",
          rep: "Farmer Jack",
          address: "123 N Boo st",
          payment: "POD",
          phone: "773-123-4567"
        }
      end

      it "creates a new vendor" do
        expect do
          post :create, vendor: valid_vendor_params
        end.to change(Vendor, :count).from(0).to(1)
      end

      it "redirects to vendors page" do
        post :create, vendor: valid_vendor_params
        expect(response).to redirect_to(vendors_path)
      end

      it "shows flash message upon successful creation" do
        post :create, vendor: valid_vendor_params
        expect(flash[:notice]).to eq("Vendor successfully created")
      end
    end

    context "with invalid params" do
      def invalid_vendor_params
        {
          name: "",
          rep: "Farmer Jill",
          address: "543 S Hampton",
          payment: "Check"
        }
      end

      it "does not create a new vendor" do
        expect do
          post :create, vendor: invalid_vendor_params
        end.to_not change(Vendor, :count)
      end

      it "re-renders the form" do
        post :create, vendor: invalid_vendor_params
        expect(response).to render_template(:new)
      end

      it "displays the correct error messages" do
        post :create, vendor: invalid_vendor_params
        expect(assigns(:errors)).to eq(["Name can't be blank"])
      end
    end
  end

  describe "#edit" do
    let(:edit_vendor) { FactoryGirl.create :vendor }

    before do
      get :edit, id: edit_vendor.id
    end

    it "returns a view (form)" do
      expect(response).to render_template(:edit)
    end

    it "returns http success" do
      expect(response).to be_ok
      expect(response).to have_http_status(:success)
    end
  end

  describe "#update" do
    let!(:vendor) do
      FactoryGirl.create(:vendor,
                          name: "How Now Brown Cow Meats",
                          rep: "Farmer Jack",
                          category: "Meat",
                          address: "123 N Nort",
                          payment: "No charge",
                          phone: "773-123-4567"
                        )
    end

    let!(:updated_params) do
      attributes_for(:vendor,
                      name: "Sparkle Berry",
                      rep: "Patty Smith",
                      category: "Produce",
                      address: "555 W West",
                      payment: "Pay on Delivery",
                      phone: "312-123-4567"
                    )
    end

    it "updates the name" do
      vendor.name = updated_params[:name]
      put :update, id: vendor.id, vendor: vendor.attributes
      expect(Vendor.find(vendor.id).name).to eq(updated_params[:name])
    end

    it "updates the representative" do
      vendor.rep = updated_params[:rep]
      put :update, id: vendor.id, vendor: vendor.attributes
      expect(Vendor.find(vendor.id).rep).to eq(updated_params[:rep])
    end

    it "updates the category" do
      vendor.category = updated_params[:category]
      put :update, id: vendor.id, vendor: vendor.attributes
      expect(Vendor.find(vendor.id).category).to eq(updated_params[:category])
    end

    it "updates the address" do
      vendor.address = updated_params[:address]
      put :update, id: vendor.id, vendor: vendor.attributes
      expect(Vendor.find(vendor.id).address).to eq(updated_params[:address])
    end

    it "updates the payment type" do
      vendor.payment = updated_params[:payment]
      put :update, id: vendor.id, vendor: vendor.attributes
      expect(Vendor.find(vendor.id).payment).to eq(updated_params[:payment])
    end

    it "updates the phone number" do
      vendor.phone = updated_params[:phone]
      put :update, id: vendor.id, vendor: vendor.attributes
      expect(Vendor.find(vendor.id).phone).to eq(updated_params[:phone])
    end
  end

  describe "#destroy" do
    let!(:delete_vendor) { FactoryGirl.create(:vendor, :with_products)  }

    it "should destroy the vendor" do
      expect do
        delete :destroy, id: delete_vendor.id
      end.to change(Vendor, :count).from(1).to(0)
    end

    it "should destroy the vendor's products" do
      expect do
        delete :destroy, id: delete_vendor.id
      end.to change(Product, :count).from(10).to(0)
    end

    it "should redirect to vendors path" do
      delete :destroy, id: delete_vendor.id
      expect(response).to redirect_to(vendors_path)
    end

    it "should display a notice" do
      delete :destroy, id: delete_vendor.id
      expect(flash[:notice]).to eq("Vendor and products were deleted")
    end
  end
end
