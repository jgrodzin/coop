require "rails_helper"

describe MembersController, type: :controller do
  let!(:members) { FactoryGirl.create_list :member, 10 }
  let!(:member) { members.first }
  let!(:admin) { FactoryGirl.create(:member, admin: true) }

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

  context "#edit" do
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

      context do
        let!(:update_member) { FactoryGirl.create(:member, first_name: "Water", last_name: "Bottle") }
        updated_params = FactoryGirl.attributes_for(:member, first_name: "Tea", last_name: "Time", zip: 60_606)

        updated_params.each do |attribute, value|
          it "updates #{attribute}" do
            current_value = update_member.send("#{attribute}")
            new_value = updated_params[attribute]
            put :update, id: update_member.id, member: updated_params
            expect(Member.find(update_member.id).send("#{attribute}")).to eq(new_value)
          end
        end
      end
    end
  end
end
