require_relative 'boot'

require 'rails/all'
# require 'rails'
# require 'active_model/railtie'
# # require 'active_job/railtie'
# require 'active_record/railtie'
# require 'active_storage/engine'
# require 'action_controller/railtie'
# require 'action_mailer/railtie'
# require 'action_view/railtie'
# require 'action_cable/engine'
# # require 'sprockets/railtie'
# # require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Olubalance
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.2

    # olubalance Version
    config.version = "1.8.6"

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Enforce javascript engine (not coffeescript)
    config.generators.javascript_engine = :js

    # Force schema format to SQL since schema.db doesn't include
    # Postgres views
    config.active_record.schema_format = :sql

    # Dial in generators for Rspec
    config.generators do |g|
      g.text_framework :rspec,
        fixtures: false,
        view_specs: false,
        helper_specs: false,
        routing_specs: false
    end
  end
end
