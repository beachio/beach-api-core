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

module BeachApiCore
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
