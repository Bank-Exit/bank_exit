require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
# require "action_mailbox/engine"
# require 'action_text/engine'
require 'action_view/railtie'
require 'action_cable/engine'
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module BankExit
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks patches])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    config.time_zone = 'Europe/Paris'
    # config.eager_load_paths << Rails.root.join("extras")

    config.i18n.available_locales = %i[en fr es de it]
    config.i18n.default_locale = :en
    config.i18n.fallbacks = true

    config.i18n_human_languages = {
      fr: 'Français',
      en: 'English',
      es: 'Español',
      de: 'Deutsch',
      it: 'Italiano'
    }.freeze

    config.active_record.encryption.primary_key = ENV.fetch('RAILS_ENCRYPTION_PRIMARY_KEY', nil)
    config.active_record.encryption.deterministic_key = ENV.fetch('RAILS_ENCRYPTION_DETERMINISTIC_KEY', nil)
    config.active_record.encryption.key_derivation_salt = ENV.fetch('RAILS_ENCRYPTION_KEY_DERIVATION_SALT', nil)

    config.x.features = config_for(:features)
  end
end
