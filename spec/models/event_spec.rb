require "rails_helper"

describe Event do
  context "assocations" do
    it { should belong_to :team }
    it { should have_many :inventories }
    it { should have_many(:vendors).through(:inventories) }
    it { should have_many(:sellable_products).through(:inventories) }
    it { should have_many :shopping_carts }
    it { should have_many :shopping_carts }
  end

  context "validations" do
    it { should validate_presence_of :team_id }
  end

  it "displays date in words" do
    event = FactoryGirl.create(:event, date: "2014-11-25")
    expect(event.date_in_words).to eq("November 25, 2014")
  end
end
