# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)

# Prevent running in production mode
abort('The Rails environment is running in production mode!') if Rails.env.production?

# Load RSpec and other testing libraries
require 'spec_helper'
require 'rspec/rails'
require 'capybara/rspec'

# Automatically require any support files
Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

# Ensure the database schema is up to date before running tests
# begin
#   ActiveRecord::Migration.maintain_test_schema!
# rescue ActiveRecord::PendingMigrationError => e
#   puts e.to_s.strip
#   # For Rails 6+ migration handling
#   migration_paths = ActiveRecord::Migrator.migrations_paths
#   migration_context = ActiveRecord::MigrationContext.new(migration_paths, ActiveRecord::SchemaMigration)
#   migration_context.migrate # Applies pending migrations if needed
#   ActiveRecord::Migration.maintain_test_schema!
# end

# Shoulda Matchers configuration
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

RSpec.configure do |config|
  # Use transactional fixtures (Rails' default for managing test DB)
  config.use_transactional_fixtures = true

  # Automatically infer spec types from file location
  config.infer_spec_type_from_file_location!

  # Filter Rails framework code from backtraces
  config.filter_rails_from_backtrace!

  # Include Devise helpers if you're using Devise for authentication
  config.include Devise::Test::IntegrationHelpers, type: :request

  # Optionally, include custom helper modules if you have them
  config.include RequestSpecHelper, type: :request

  # Additional Capybara settings if needed
  config.before(:each, type: :system) do
    driven_by(:rack_test) # Use rack_test by default for system tests without JS
  end

  # Set up specific driver for system tests involving JS
  config.before(:each, type: :system, js: true) do
    driven_by(:selenium, using: :chrome_headless)
  end

  # Automatically run migrations before the test suite
  config.before(:suite) do
    begin
      ActiveRecord::Migration.maintain_test_schema!
    rescue ActiveRecord::PendingMigrationError => e
      puts "Error during migrations: #{e.message}"
      migration_paths = ActiveRecord::Migrator.migrations_paths
      migration_context = ActiveRecord::MigrationContext.new(migration_paths, ActiveRecord::SchemaMigration)
      puts "Applying pending migrations..."
      migration_context.migrate
      ActiveRecord::Migration.maintain_test_schema!
    end
  end

end
