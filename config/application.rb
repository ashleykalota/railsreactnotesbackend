require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Ambulance4
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.2

    # Set up CORS to allow requests from your frontend
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*' # Replace with your frontend domain
        resource '*', headers: :any, methods: [:get, :post, :put, :delete, :options]
      end
    end

    # config/application.rb
    config.before_initialize do
     ENV['JWT_SECRET_KEY'] ||= 'yourSuperSecretKey'  # Fallback to your secret key if the environment variable is missing
    end

    
    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Only loads a smaller set of middleware suitable for API-only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers, and assets when generating a new resource.
    config.api_only = true

    config.google_maps_api_key = ENV['GOOGLE_MAPS_API_KEY']

  end
end
