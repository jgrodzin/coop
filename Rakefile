# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path("../config/application", __FILE__)

Rails.application.load_tasks

if Rails.env.development? || Rails.env.test?
  # Jasmine
  require "rspec/core/rake_task"
  require "rubocop/rake_task"

  RuboCop::RakeTask.new(:rubocop) do |task|
    task.options = ["-D"]
  end

  namespace :spec do
    desc "runs integration tests only"
    RSpec::Core::RakeTask.new(:integration) do |t|
      t.pattern = "spec/features/**/*_spec.rb"
      t.rspec_opts = "--tag js"
    end

    desc "Run all test suites"
    task :all do
      #Rake::Task["rubocop"].invoke
      Rake::Task["spec"].invoke
      Rake::Task["spec:integration"].invoke
    end
  end

  task(:default).clear.enhance(["spec:all"])
  #task(:default).clear.enhance(["rubocop", "spec:all"])
end
