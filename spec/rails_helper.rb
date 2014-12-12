ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../../config/environment", __FILE__)
require "capybara-screenshot/rspec"
require "capybara/rspec"
require "rspec/rails"
require "shoulda-matchers"
require "spec_helper"
require "money-rails/test_helpers"

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

RSpec.configure do |config|
  config.include MoneyRails::TestHelpers
  config.include FactoryGirl::Syntax::Methods
  config.include Warden::Test::Helpers
  config.include Devise::TestHelpers, type: :controller
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!

  config.before :suite do
    begin
      DatabaseCleaner.start

    ensure
      DatabaseCleaner.clean
    end
  end

  config.after do
    Warden.test_reset!
  end
end
