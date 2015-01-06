require "rails_helper"

describe TeamsController, type: :controller do
  let(:member) { FactoryGirl.create(:member) }
  let(:admin) { FactoryGirl.create(:member, admin: true) }

  describe "#new" do
    context "member" do
      before do
        sign_in member
        get :new
      end

      it "should be denied access" do
        expect(response).to redirect_to(root_url)
      end

      it "gives flash notice" do
        expect(response).to redirect_to(root_url)
        expect(flash[:alert]).to eq("Access denied!")
      end
    end

    context "admin" do
      before do
        sign_in admin
        get :new
      end

      it "builds a new team object" do
        expect(assigns(:team)).to be_kind_of(Team)
        expect(assigns(:team)).to_not be_persisted
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "#create" do
    context "member" do
      before do
        sign_in member
        post :create
      end

      it "should not have access" do
        expect(response).to redirect_to(root_url)
      end
    end

    context "admin" do
      before do
        sign_in admin
      end

      context "with valid params" do
        def valid_team_params
          {
            team: attributes_for(:team)
          }
        end

        it "creates a new team" do
          expect do
            post :create, valid_team_params
          end.to change(Team, :count).from(0).to(1)
        end

        it "redirects to teams path" do
          post :create, valid_team_params
          expect(response).to redirect_to(teams_admins_path)
        end

        it "sets the notice message appropriately" do
          post :create, valid_team_params
          expect(flash[:notice]).to eq("Team successfully created")
        end
      end
    end
  end

  describe "#edit" do
    it "returns http success" do
      expect(response).to be_ok
      expect(response).to have_http_status(:success)
    end
  end

  describe "#update" do
    let(:member) { FactoryGirl.create_list(:member, 3) }
    let(:team) { FactoryGirl.create(:team) }
    let(:team_members) do
      members.each do |member|
        team_members = [
          FactoryGirl.create(:team_member, team_id: team.id, member_id: member.id)
        ]
      end
    end
    let(:team_attributes) { attributes_for :team }
    let(:team_member_attributes) { attributes_for :team_member, member: FactoryGirl.create(:member, first_name: "Sasha") }

    xit "allows removal of a team member" do
    end

    xit "allows changing of team members" do
    end
  end
end
