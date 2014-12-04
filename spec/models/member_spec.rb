require "rails_helper"

describe Member do
  context "associations" do
    it { should have_many :team_members }
    it { should have_many(:teams).through(:team_members) }
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

  context "roles" do
    # it "can be an admin user"
    # it "can be a team member"
    # it "can be a leader of a team"
  end
end
