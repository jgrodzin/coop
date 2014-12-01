require "rails_helper"

describe EventsController, type: :controller do
  let(:member) { FactoryGirl.create(:member) }
  before { sign_in member }

  describe "#index" do
    before { get :index }
    render_views

    it "renders a view" do
      expect(response).to render_template(:index)
    end

    it "returns all events ordered by most recent" do
      december_event = FactoryGirl.create(:event, date: "12-12-2014")
      september_event = FactoryGirl.create(:event, date: "9-9-2014")

      expect(Event.all).to eq([december_event, september_event])
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

    ### Who tests this?
    # it "returns all member's addresses as option for event location" do
    #   members = FactoryGirl.create_list(:member, 6)
    #   expect(response).to include(members.map(&:address))
    # end
  end

  describe "#create" do
    let(:team) { FactoryGirl.create(:team) }
    let(:team_members) { FactoryGirl.create_list(:team_member, 4, team: team) }

    context "invalid params" do
      def invalid_event_params
        {
          event: attributes_for(:event),
          location: team_members.first.member.address
        }
      end

      it "does not save without a team and renders new form" do
        expect { post :create, event: invalid_event_params  }.to change { Event.count }.by(0)
        expect(response).to render_template(:new)
      end
    end

    context "valid params" do
      def valid_event_params
        {
          event: attributes_for(:event),
          team_id: team.id,
          location: team_members.first.member.address
        }
      end

      it "creates a new event" do
        expect { post :create, event: valid_event_params }.to change { Event.count }.by(1)
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
    before { get :edit, id: editable_event.id }
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
    let(:original_team) { FactoryGirl.create(:team) }
    let(:updated_team) { FactoryGirl.create(:team) }
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
    let!(:destroyable_event) { FactoryGirl.create(:event) }

    it "deletes an event" do
      expect { delete :destroy, id: destroyable_event.id }.to change { Event.count }.by(-1)
    end

    it "redirects to event page" do
      delete :destroy, id: destroyable_event.id
      expect(response).to redirect_to(events_path)
    end
  end
end
