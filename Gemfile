source 'https://rubygems.org'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 8.0.0'
# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem 'propshaft'
# Use sqlite3 as the database for Active Record
gem 'sqlite3', '>= 2.1'
# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '>= 5.0'
# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem 'importmap-rails'
# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'turbo-rails'
# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'stimulus-rails'
# Use Tailwind CSS [https://github.com/rails/tailwindcss-rails]
gem 'tailwindcss-rails'
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem 'jbuilder'

gem 'ostruct' # Fix deprecation warning with json gem dropping this dependency

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem 'bcrypt', '~> 3.1.7'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[windows jruby]

# Use the database-backed adapters for Rails.cache, Active Job, and Action Cable
gem 'solid_cable'
gem 'solid_cache'
gem 'solid_queue'

gem 'action_policy'
gem 'active_analytics'
gem 'active_storage_validations'
gem 'blueprinter'
gem 'breadcrumbs_on_rails'
gem 'chartkick'
gem 'country_select'
gem 'crawler_detect'
gem 'diffy'
gem 'faker'
gem 'geocoder'
gem 'groupdate'
gem 'httparty'
gem 'inline_svg'
gem 'logstop'
gem 'lucide-rails'
gem 'meta-tags'
gem 'mission_control-jobs'
gem 'mobility'
gem 'osrm_text_instructions'
gem 'pagy', '~> 9'
gem 'positioning'
gem 'pretender'
gem 'rails_autolink'
gem 'rails-i18n'
gem 'route_translator'
gem 'rqrcode'
gem 'rswag-api'
gem 'rswag-ui'
gem 'simple_form'
gem 'sitemap_generator'
gem 'slim-rails'
gem 'sorcery'
gem 'turbo_power'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Deploy this application anywhere as a Docker container [https://kamal-deploy.org]
gem 'kamal', require: false

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem 'thruster', require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem 'image_processing', '~> 1.2'

group :development, :staging do
  gem 'debugbar'
end

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri windows], require: 'debug/prelude'

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem 'brakeman', require: false

  gem 'annotaterb', require: false
  gem 'bullet'
  gem 'chusaku'
  gem 'dotenv-rails'
  gem 'rspec-rails'
  gem 'rswag-specs'
  gem 'rubocop'
  gem 'rubocop-performance'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
end

group :development do
  gem 'hotwire-spark'
  gem 'letter_opener_web'

  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'web-console'
end

group :test do
  gem 'factory_bot_rails'
  gem 'shoulda-matchers'
  gem 'simplecov'
  gem 'webmock'
end
