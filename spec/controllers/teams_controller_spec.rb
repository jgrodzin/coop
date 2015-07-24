require "rails_helper"

describe TeamsController, type: :controller do
  let!(:member) { FactoryGirl.create(:member) }
  let!(:admin) { FactoryGirl.create(:admin) }

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
        let(:member_2) { create(:member, first_name: "Michael") }
        let(:valid_team_params) do
          attributes_for(:team, name: "Green", number: 333).merge(member_ids: [""], leader_ids: [""])
        end

        it "creates a new team" do
          expect do
            post :create, team: valid_team_params
          end.to change(Team, :count).from(0).to(1)
        end

        it "associates members with the created team" do
          post :create, team: valid_team_params.merge(member_ids: [member.id, member_2.id, ""])
          expect(Team.last.members).to match_array([member, member_2])
        end

        it "associates a member as team leader" do
          post :create, team: valid_team_params.merge(leader_ids: [member_2.id, ""])
          expect(Team.last.team_members.where(leader: true).map(&:member)).to eq([member_2])
        end

        # does this belong here?
        it "can have multiple team leaders" do
          member_3 = create(:member, first_name: "Angela")
          post :create, team: valid_team_params.merge(leader_ids: [member_2.id, member_3.id, ""]).merge(member_ids: [member.id, ""])
          expect(Team.last.leaders).to match_array([member_2, member_3])
          expect(Team.last.members).to match_array([member_2, member_3, member])
        end

        it "redirects to teams path" do
          post :create, team: valid_team_params
          expect(response).to redirect_to(teams_admins_path)
        end

        it "sets the notice message appropriately" do
          post :create, team: valid_team_params
          expect(flash[:notice]).to eq(subject.request.flash[:notice])
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
    let!(:members) { create_list(:member, 3) }
    let!(:member1) { members.first }
    let!(:member2) { members.second }
    let!(:member3) { members.third }
    let!(:team) { create(:team) }

    before do
      team.members << members
      team.members.first.leader!
    end

    it "removes team members" do
      params =  attributes_for(:team).merge(leader_ids: [member1.id], member_ids: [member1.id, member2.id])
      team.attributes = params
      put :update, id: team.id, team: team.attributes
      team.reload
      expect(team.members).to_not include(member3)
    end

    it "adds team members" do
      new_member_1 = create(:member)
      new_member_2 = create(:member)
      params_for_adding_members = attributes_for(:team).merge(member_ids: [member1.id, new_member_1.id, new_member_2.id])
      team.attributes = params_for_adding_members
      put :update, id: team, team: team.attributes
      expect(Team.find(team.id).members).to match_array([member1, new_member_2, new_member_1])
    end

    it "adds a leader" do
      expect(team.leaders.first).to eq(member1)
      new_leader = create(:team_member, member_id: Member.second.id, leader: true)
      params_for_adding_leader = attributes_for(:team).merge(leader_ids: [member1, new_leader.member])
      team.leaders = params_for_adding_leader[:leader_ids]

      put :update, id: team, team: team.attributes
      team.reload
      expect(team.leaders).to match_array([member1, new_leader.member])
    end

    it "change old leader to new leader" do
      expect(team.leaders.first).to eq(TeamMember.first.member)
      new_leader = create(:team_member, member_id: Member.second.id, leader: true)
      params_for_adding_leader = attributes_for(:team).merge(leader_ids: [new_leader.member])
      team.leaders = params_for_adding_leader[:leader_ids]

      put :update, id: team, team: team.attributes
      expect(Team.find(team.id).leaders).to eq([new_leader.member])
    end
  end
end
