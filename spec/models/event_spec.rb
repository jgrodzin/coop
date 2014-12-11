require "rails_helper"

describe Event do
  context "assocations" do
    it { should belong_to :team }
    it { should have_many(:vendors).through(:products) }
    it { should have_many(:products) }
    it { should have_many :shopping_carts }
  end

  context "validations" do
    it { should validate_presence_of :team_id }
  end

  describe "scopes" do
    let(:past_event) { FactoryGirl.create(:event, date: 2.days.ago) }
    let(:upcoming_event) { FactoryGirl.create(:event, date: 2.days.from_now) }
    describe "past_events" do
      it "returns events that have already occurred" do
        expect(Event.past_events).to include(past_event)
        expect(Event.past_events).to_not include(upcoming_event)
      end
    end

    describe "upcoming_events" do
      it "it returns events that are in the future" do
        expect(Event.upcoming_events).to include(upcoming_event)
        expect(Event.upcoming_events).to_not include(past_event)
      end
    end
  end

  it "displays date in words" do
    event = FactoryGirl.create(:event, date: "2014-11-25")
    expect(event.date_in_words).to eq("November 25, 2014")
  end
end
