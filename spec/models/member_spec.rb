require "rails_helper"

describe Member do
  context "associations" do
    it { should have_many :team_memberships }
    it { should have_many(:teams).through(:team_memberships) }
    it { should have_many :shopping_carts }
    it { should have_many(:events).through(:teams) }
  end

  context "validations" do
    it { should validate_presence_of :first_name }
    it { should validate_presence_of :last_name }
  end

  context "formatting" do
    describe "name" do
      it "returns full name" do
        member = FactoryGirl.create(:member, first_name: "Cathy", last_name: "Grodzins")
        expect(member.name).to eq("Cathy Grodzins")
      end
    end

    describe "address" do
      it "returns full address with unit number" do
        member = FactoryGirl.create(:member, street_address: "123 E Boo", unit_number: "apt 2", city: "Chicago", state: "IL", zip: "60606")
        expect(member.address).to eq("123 E Boo, apt 2, Chicago, IL 60606")
      end

      it "returns full address without unit number" do
        member = FactoryGirl.create(:member, street_address: "123 E Boo", unit_number: nil, city: "Chicago", state: "IL", zip: "60606")
        expect(member.address).to eq("123 E Boo, Chicago, IL 60606")
      end
    end
  end

  describe "#admin!" do
    it "changes member to be an admin" do
      member = FactoryGirl.create :member
      expect(member.admin?).to be false
      member.admin!
      expect(member.admin?).to be true
    end
  end

  context "leader actions" do
    let!(:member) { FactoryGirl.create :member }
    let!(:team_member) { FactoryGirl.create(:team_member, member: member) }

    describe "#leader?" do
      it "returns member's leadership status" do
        expect(team_member.member.leader?).to be false
      end
    end

    describe "#leader!" do
      it "makes the member a team leader" do
        member.leader!
        team_member.reload
        expect(team_member.member.leader?).to be true
        expect(team_member.leader?).to be true
      end
    end
  end
end
