require "rails_helper"

describe Team do
  it { should have_many :members }
  it { should have_many :leaders }
end
