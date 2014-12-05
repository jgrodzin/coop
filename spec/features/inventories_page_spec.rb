require "rails_helper"

describe "Inventory page" do
  let(:member) { FactoryGirl.create :member }
  let(:event) { FactoryGirl.create(:event) }

  before do
    login_as member
  end

  describe "index" do
    before { visit event_inventories_path(event_id: event) }
  end
end
