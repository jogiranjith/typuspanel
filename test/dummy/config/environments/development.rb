Dummy::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # config.assets.debug = true
  config.assets.debug = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test
end

Typus.setup do |config|
  config.mailer_sender = "admin@example.com"

  # Authenticate using `:none_with_role`
  # config.authentication = :none_with_role

  # Authenticate using `:http_basic` authentication.
  # config.authentication = :http_basic
  # config.username = 'admin'
  # config.password = 'columbia'

  # Authenticate using typus provided authentication.
  config.authentication = :session
  config.user_class_name = "TypusUser"

  # Authenticate using devise.
  # config.authentication = :devise
  # config.user_class_name = "DeviseUser"
end
