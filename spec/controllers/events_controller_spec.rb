require "rails_helper"

describe EventsController, type: :controller do
  let(:member) { FactoryGirl.create(:member) }

  before do
    sign_in member
  end

  describe "index" do
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

  describe "new" do
    before { get :new }

    it "assigns new event to variable" do
      expect(assigns(:event)).to_not be_persisted
    end

    it "returns all teams as option for event team" do
      expect(assigns(:teams)).to eq(Team.all)
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    # it "returns all member's addresses as option for event location" do
    #   members = FactoryGirl.create_list(:member, 6)
    #   expect(response).to include(members.map(&:address))
    # end
  end

  describe "create" do
    let(:team) { FactoryGirl.create(:team) }
    let(:team_members) { FactoryGirl.create_list(:team_member, 4, team: team) }

    def event_params
      {
        event: attributes_for(:event),
        # team_id: team.id,
        location: team_members.first.member.address
      }
    end

    context "invalid params" do
      it "does not save an event without a team" do
        expect { post :create, event: event_params  }.to change { Event.count }.by(0)
      end


    end
  end
end

# describe "#create" do
#     context "invalid params" do
#       it "does not save an empty payment" do
#         expect{ post :create, payment_params }.to change{ Payment.count }.by(0)
#       end

#       it "renders the new form" do
#         post :create, payment_params
#         expect(response).to render_template(:new)
#       end

#       it "finds the loans belonging to the dealership, ordered by floored_date, and principal_amount desc" do
#         dealership.loans.destroy_all
#         first_loan = create(:loan, floored_date: 2.days.ago, status: Loan::States::OPEN, principal_amount_cents: 100, dealership: dealership)
#         second_loan = create(:loan, floored_date: 2.days.ago, status: Loan::States::OPEN, principal_amount_cents: 99, dealership: dealership)
#         last_loan = create(:loan, floored_date: 1.day.ago, status: Loan::States::OPEN, dealership: dealership)

#         get :new, dealership_id: dealership.id

#         expect(assigns(:loans).first.id).to eq(first_loan.id)
#         expect(assigns(:loans).second.id).to eq(second_loan.id)
#         expect(assigns(:loans).last.id).to eq(last_loan.id)
#       end
#     end

#     context "valid params" do
#       it "creates a payment" do
#         expect { post :create, nested_payment_params }.to change{ Payment.count }.by(1)
#       end

#       it "creates the loan payments" do
#         expect{ post :create, nested_payment_params }.to change{ LoanPayment.count }.by(1)
#       end

#       it "redirects to the dealership show page with a success message" do
#         post :create, nested_payment_params
#         expect(response).to redirect_to(dealership_path(dealership))
#         expect(flash[:notice]).to eq("Payment successfully added!")
#       end

#       it "saves the dealership_id" do
#         post :create, nested_payment_params
#         expect(Payment.first.dealership).to eq(dealership)
#       end

#       it "saves the loan_id" do
#         post :create, nested_payment_params
#         expect(LoanPayment.first.loan).to eq(open_loan)
#       end
#     end
#   end

