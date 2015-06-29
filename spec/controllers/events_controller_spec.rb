require "rails_helper"

describe EventsController, type: :controller do
  let(:member) { create(:member) }
  let(:admin) { create(:admin) }
  let!(:december_event) { create(:event, date: "12-12-2014") }
  let!(:september_event) { create(:event, date: "9-9-2014") }

  before do
    sign_in admin
  end

  describe "#index" do
    before do
      get :index
      sign_in member
    end

    render_views

    it "renders a view" do
      expect(response).to render_template(:index)
    end

    it "returns all events ordered by most recent" do
      expect(Event.all).to eq([december_event, september_event])
    end

    context "views" do
      render_views
      xit "correctly displays leader name with pluralization" do
        expect(response.body).to have_text("Team Leader")
      end
    end
  end

  describe "#show" do
    let!(:event) { create(:event) }

    before do
      get :show, id: event.id
      sign_in member
    end

    render_views

    it "renders a view" do
      expect(response).to render_template(:show)
    end
  end

  describe "#new" do
    before { get :new }

    it "builds a new event object" do
      expect(assigns(:event)).to be_kind_of(Event)
    end

    it "assigns new event to variable" do
      expect(assigns(:event)).to_not be_persisted
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end
  end

  describe "#create" do
    let(:team) { FactoryGirl.create(:team) }
    let(:team_members) { FactoryGirl.create_list(:team_member, 4, team: team) }

    context "with invalid params" do
      describe "without a team" do
        def invalid_event_params
          {
            event: attributes_for(:event),
            location: team_members.first.member.address,
            date: "2015-12-13"
          }
        end

        it "does not save without a team" do
          expect do
            post :create, event: invalid_event_params
          end.to_not change(Event, :count)
        end

        it "re-renders the form" do
          post :create, invalid_event_params
          expect(response).to render_template(:new)
        end

        it "displays the correct error messages" do
          post :create, event: invalid_event_params
          expect(assigns(:errors)).to eq(["Team can't be blank"])
        end
      end

      describe "without a date" do
        def invalid_event_params
          {
            event: attributes_for(:event),
            location: team_members.first.member.address,
            team_id: team.id
          }
        end

        it "does not sav without a date" do
          expect do
            post :create, event: invalid_event_params
          end.to_not change(Event, :count)
        end

        it "re-renders the form" do
          post :create, invalid_event_params
          expect(response).to render_template(:new)
        end

        it "displays the correct error messages" do
          post :create, event: invalid_event_params
          expect(assigns(:errors)).to eq(["Date can't be blank"])
        end
      end
    end

    context "with valid params" do
      def valid_event_params
        {
          event: attributes_for(:event),
          team_id: team.id,
          location: team_members.first.member.address,
          date: "2015-12-12"
        }
      end

      it "creates a new event" do
        expect do
          post :create, event: valid_event_params
        end.to change(Event, :count).by(1)
      end

      it "redirects to events page" do
        post :create, event: valid_event_params
        expect(response).to redirect_to(events_path)
      end

      it "shows a flash message upon successful creation" do
        post :create, event: valid_event_params
        expect(flash[:notice]).to eq("Event successfully created")
      end
    end
  end

  describe "#edit" do
    let(:editable_event) { FactoryGirl.create(:event) }

    before do
      get :edit, id: editable_event.id
    end

    render_views

    it "returns a view" do
      expect(response).to render_template(:edit)
    end

    it "returns http success" do
      expect(response).to be_ok
      expect(response).to have_http_status(:success)
    end
  end

  describe "#update" do
    let(:original_team) { FactoryGirl.create(:team_with_associations) }
    let(:updated_team) { FactoryGirl.create(:team_with_associations) }
    let!(:updateable_event) { FactoryGirl.create(:event, date: "2014-1-1", team_id: original_team.id, location: "123 E Foo") }
    let!(:updated_params) { attributes_for(:event, date: "2014-2-2", team_id: updated_team.id, location: "321 W Bar") }

    it "updates the date" do
      updateable_event.date = updated_params[:date]
      put :update, id: updateable_event, event: updateable_event.attributes
      expect(Event.find(updateable_event.id).date).to eq(updated_params[:date].to_date)
    end

    it "updates the team" do
      updateable_event.team_id = updated_params[:team_id]
      put :update, id: updateable_event, event: updateable_event.attributes
      expect(Event.find(updateable_event.id).team_id).to eq(updated_params[:team_id])
    end

    it "updates the location" do
      updateable_event.location = updated_params[:location]
      put :update, id: updateable_event, event: updateable_event.attributes
      expect(Event.find(updateable_event.id).location).to eq(updated_params[:location])
    end
  end

  describe "#destroy" do
    let!(:destroyable_event) { FactoryGirl.create(:event, :with_products) }

    it "deletes an event" do
      expect do
        delete :destroy, id: destroyable_event.id
      end.to change(Event, :count).by(-1)
    end

    it "redirects to event page" do
      delete :destroy, id: destroyable_event.id
      expect(response).to redirect_to(events_path)
    end

    it "does not destroy inventory" do
      expect do
        delete :destroy, id: destroyable_event.id
      end.to_not change(Product, :count)
    end

    xit "does not destroy member shopping carts" do
      create(:shopping_cart, event_id: destroyable_event.id, member_id: member.id)
      delete :destroy, id: destroyable_event.id
      expect(ShoppingCart.where(event_id: destroyable_event.id).first).to be_valid
    end

    xit "does not destroy cart items associated with products from event" do
      shopping_cart = create(:shopping_cart, event_id: destroyable_event.id, member_id: member.id)
      create(:cart_item, shopping_cart: shopping_cart, product: destroyable_event.products.first)
      create(:cart_item, shopping_cart: shopping_cart, product: destroyable_event.products.second)
      create(:cart_item, shopping_cart: shopping_cart, product: destroyable_event.products.third)
      delete :destroy, id: destroyable_event.id
      expect(ShoppingCart.where(event_id: destroyable_event.id).first.cart_items.first).to be_valid
    end

    it "leaves products valid without event id" do
      delete :destroy, id: destroyable_event.id
      expect(Product.first).to be_valid
    end
  end
end
