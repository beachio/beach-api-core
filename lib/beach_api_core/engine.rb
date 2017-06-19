require 'versionist'
require 'doorkeeper'
require 'baby_squeel'
require 'active_model_serializers'
require 'pundit'
require 'interactor'
require 'slim'
require 'apipie-rails'
require 'activerecord_lookup_or_initialize'
require 'rmagick'
require 'draper'
require 'sidekiq'

module BeachApiCore
  # Controller names that should be filtered from available controller list
  mattr_accessor :filtered_controllers
  @@filtered_controllers = []

  # Controller names' prefixes that should be filtered from available controller list
  mattr_accessor :filtered_controller_prefixes
  @@filtered_controller_prefixes = []

  # Service category name that contains full permissions service
  mattr_accessor :grant_service_category_name
  @@grant_service_category_name = 'Main'

  # Service name that grants all permissions to application
  mattr_accessor :grant_service_name
  @@grant_service_name = 'Grant'

  def self.setup
    yield self
  end

  class Engine < ::Rails::Engine
    isolate_namespace BeachApiCore
    class << self
      attr_accessor :elasticsearch_enabled
    end

    config.generators do |g|
      g.test_framework :rspec, fixture: false
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
      g.assets false
      g.helper false
    end

    config.after_initialize do
      @elasticsearch_enabled = ENV['ELASTICSEARCH_ENABLED'] == 'true'
    end
  end
  Doorkeeper = ::Doorkeeper
  Apipie = ::Apipie
end
