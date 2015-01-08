require "rails_helper"

describe TeamsController, type: :controller do
  let!(:member) { FactoryGirl.create(:member) }
  let!(:admin) { FactoryGirl.create(:member, admin: true) }

  describe "#index" do
    let!(:team_1) { FactoryGirl.create(:team, name: "Green") }
    let!(:team_2) { FactoryGirl.create(:team, name: "Blue") }
    let!(:team_membership_1) { FactoryGirl.create(:team_member, member_id: member.id, team_id: team_1.id, leader: true) }
    let!(:team_membership_2) { FactoryGirl.create(:team_member, member_id: member.id, team_id: team_2.id) }

    before do
      sign_in member
      get :index
    end

    render_views

    it "renders a view" do
      expect(response).to render_template(:index)
    end

    it "finds all teams current member is on" do
      expect(assigns(:teams)).to eq([team_1, team_2])
    end
  end

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
        let(:valid_team_params) do
          attributes_for(:team, name: "Green", number: 333).merge(member_ids: [""])
        end

        it "creates a new team" do
          expect do
            # binding.pry
            post :create, team: valid_team_params
          end.to change(Team, :count).from(0).to(1)
        end

        it "assigns team members" do
          post :create, team: valid_team_params.merge(member_ids: [member.id, ""])

          expect(Team.last.members).to eq([member])
        end

        it "redirects to teams path" do
          post :create, team: valid_team_params
          expect(response).to redirect_to(teams_admins_path)
        end

        it "sets the notice message appropriately" do
          post :create, team: valid_team_params
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
