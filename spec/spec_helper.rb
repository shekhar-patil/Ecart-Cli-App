require "bundler/setup"
require './lib/datastore.rb'

RSpec.configure do |config|
  # create new database each time rspec is running
  system('rm -r test_db') # drop previous test_db
  system('mkdir test_db') # create new test_db

  ENV['env'] = 'testing' # this is to check environment in the app.

  # change database folder for testing
  Datastore.database_folder = 'test_db/'
  require "e_cart"

  Dir["./lib/*.rb"].each {|file| require file }

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
