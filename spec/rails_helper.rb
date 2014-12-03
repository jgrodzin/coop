ENV["RAILS_ENV"] ||= "test"
require "spec_helper"
require File.expand_path("../../config/environment", __FILE__)
require "capybara/rspec"
require "rspec/rails"
require "shoulda-matchers"
require "money-rails/test_helpers"

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include MoneyRails::TestHelpers
  config.include Devise::TestHelpers, type: :controller
  config.include Warden::Test::Helpers
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!

  # config.before :suite do
  #   begin
  #     DatabaseCleaner.start
  #     FactoryGirl.lint
  #   ensure
  #     DatabaseCleaner.clean
  #   end
  # end
end
