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
    let!(:members) { FactoryGirl.create_list(:member, 3) }
    let!(:original_team) { FactoryGirl.create(:team) }
    let!(:team_members) do
      members.each do |member|
        FactoryGirl.create(:team_member, team_id: original_team.id, member_id: member.id)
      end
      TeamMember.first.update_attributes(leader: true)
    end

    it "removes team members" do
      params_for_less_members = attributes_for(:team).merge(member_ids: [Member.first, Member.second])
      original_team.members = params_for_less_members[:member_ids]

      put :update, id: original_team, team: original_team.attributes
      expect(Team.find(original_team.id).members).to eq(params_for_less_members[:member_ids])
    end

    it "adds team members" do
      new_member_1 = create(:member)
      new_member_2 = create(:member)
      params_for_adding_members = attributes_for(:team).merge(member_ids: [Member.first, Member.second, Member.third, Member.fourth, Member.fifth, new_member_1, new_member_2])
      original_team.members = params_for_adding_members[:member_ids]

      put :update, id: original_team, team: original_team.attributes
      expect(Team.find(original_team.id).members).to match_array(Member.all)
    end

    it "adds a leader" do
      expect(original_team.leaders.first).to eq(TeamMember.first.member)
      new_leader = create(:team_member, member_id: Member.second.id, leader: true)
      new_params = attributes_for(:team).merge(leader_ids: [Member.first, new_leader.member])
      original_team.leaders = new_params[:leader_ids]

      put :update, id: original_team, team: original_team.attributes
      expect(Team.find(original_team.id).leaders).to match_array([Member.first, new_leader.member])
    end

    it "change old leader to new leader" do
      expect(original_team.leaders.first).to eq(TeamMember.first.member)
      new_leader = create(:team_member, member_id: Member.second.id, leader: true)
      new_params = attributes_for(:team).merge(leader_ids: [new_leader.member])
      original_team.leaders = new_params[:leader_ids]

      put :update, id: original_team, team: original_team.attributes
      expect(Team.find(original_team.id).leaders).to eq([new_leader.member])
    end
  end
end
