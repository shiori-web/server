require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Shiori
  class Application < Rails::Application
    config.load_defaults 5.2
    config.generators.system_tests = nil

    config.i18n.default_locale = :en
    config.i18n.available_locales = [:en, :km]

    lib_dirs = Dir[Rails.root.join('lib').to_s]
    config.autoload_paths += lib_dirs
    config.eager_load_paths += lib_dirs

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', headers: :any, methods: %i[get post options]
      end
    end
  end
end
