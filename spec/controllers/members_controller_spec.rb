require "rails_helper"

describe MembersController, type: :controller do
  let!(:members) { FactoryGirl.create_list :member, 10 }
  let!(:member) { members.first }
  let!(:admin) { FactoryGirl.create(:admin) }

  describe "#index" do
    context "logged in as member" do

      before do
        sign_in member
        get :index
      end

      render_views

      it "should return all members ordered by last name" do
        expect(assigns(:members)).to eq(Member.all.order(:last_name))
      end

      it "should not have an add member link" do
        assert_select "a[href='/members/new']", false
      end
    end

    context "logged in as admin" do
      before do
        sign_in admin
        get :index
      end

      render_views

      it "should return all members ordered by last name" do
        expect(assigns(:members)).to eq(Member.all.order(:last_name))
      end

      it "should have an add member link" do
        assert_select "a[href='/members/new']"
      end
    end
  end

  describe "#show" do
    context "Admin" do
      before do
        sign_in admin
        get :show, id: member.id
      end

      render_views

      it "renders a view" do
        expect(response).to render_template(:show)
      end

      it "shows selected member's name" do
        assert_select "h2", "#{member.name}"
      end

      it "shows an edit link" do
        assert_select "a[href='/members/#{member.id}/edit']"
      end
    end

    context "Member" do
      before do
        sign_in member
        get :show, id: member.id
      end

      it "renders a view" do
        expect(response).to render_template(:show)
      end

      it "does not show an edit link" do
        assert_select "a[href='/members/#{member.id}/edit']", false
      end
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

      it "builds a new member object" do
        expect(assigns(:member)).to be_kind_of(Member)
        expect(assigns(:member)).to_not be_persisted
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
        let!(:new_member) { FactoryGirl.attributes_for(:member) }

        it "creates a new member" do
          expect do
            post :create, member: new_member
          end.to change(Member, :count).by(1)
        end

        it "it sets the correct name" do
          post :create, member: new_member
          expect(Member.last.first_name).to eq(new_member[:first_name])
        end

        it "does not belong to a team yet" do
          post :create, member: new_member
          expect(Member.last.team_members).to be_empty
        end

        it "sets leader status to false by default" do
          post :create, member: new_member
          expect(Member.last.leader?).to_not be true
          ### help
        end

        xit "sets a default password" do
          ### help
        end

        it "sets admin status to false by default" do
          post :create, member: new_member
          expect(Member.last.admin?).to be false
        end

        it "redirects to members page" do
          post :create, member: new_member
          expect(response).to redirect_to(members_path)
        end

        it "sets the notice message appropriately" do
          post :create, member: new_member
          expect(flash[:notice]).to eq("Member successfully created")
        end
      end
    end
  end

  describe "#edit" do
    context "member" do
      before do
        sign_in member
        get :edit, id: member.id
      end

      it "should be denied access" do
        expect(response).to redirect_to(root_url)
      end
    end

    context "admin" do
      before do
        sign_in admin
        get :edit, id: member.id
      end

      it "gets access and renders a view" do
        expect(response).to render_template(:edit)
      end

      it "gets http success" do
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "#update" do
    context "member" do
      before do
        sign_in member
        put :update, id: member.id
      end

      it "should not have access" do
        expect(response).to redirect_to(root_url)
      end
    end

    context "admin" do
      before do
        sign_in admin
      end

      let!(:update_member) { FactoryGirl.create(:member, first_name: "Water", last_name: "Bottle", password: "password") }
      updated_params = FactoryGirl.attributes_for(:member, first_name: "Tea", last_name: "Time", zip: 60_606, password: Devise.friendly_token.first(10))

      # it updates ALL params, don't iterate through each
      # updated_params.each do |attribute, value|
      #   binding.pry
      #   it "updates #{attribute}" do
      #     new_value = updated_params[attribute]
      #     put :update, id: update_member.id, member: updated_params
      #     update_member.reload
      #     expect((update_member).send("#{attribute}")).to eq(new_value)
      #   end
      # end
    end
  end
end
