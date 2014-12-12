require "rails_helper"

describe MembersController, type: :controller do
  let!(:members) { FactoryGirl.create_list :member, 10 }

  describe "#index" do
    context "logged in as member" do
      let(:member) { members.first }

      before do
        sign_in member
      end

      it "should return all members ordered by last name" do
        get :index
        expect(assigns(:members)).to eq(Member.all.order(:last_name))
      end
    end

    context "logged in as admin" do
      let(:admin) { FactoryGirl.create(:member, admin: true) }

      before do
        sign_in admin
      end

      it "should return all members ordered by last name" do
        get :index
        expect(assigns(:members)).to eq(Member.all.order(:last_name))
      end
    end
  end

  describe "#show" do

  end

  describe "#new" do

  end
end
