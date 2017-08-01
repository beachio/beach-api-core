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
require 'acts_as_downcasable_on'
require 'acts_as_strippable_on'

module BeachApiCore
  class Engine < ::Rails::Engine
    isolate_namespace BeachApiCore
    class << self
      attr_accessor :elasticsearch_enabled
    end

    initializer :beach_api_core do
      ActiveAdmin.application.load_paths.unshift(File.join(config.root, 'lib', 'admin')) if defined?(ActiveAdmin)
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
