require 'versionist'
require 'doorkeeper'
require 'baby_squeel'
require 'active_model_serializers'
require 'pundit'
require 'interactor'
require 'slim'
require 'apipie-rails'
require 'activerecord_lookup_or_initialize'

module BeachApiCore
  class Engine < ::Rails::Engine
    isolate_namespace BeachApiCore

    config.generators do |g|
      g.test_framework :rspec, fixture: false
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
      g.assets false
      g.helper false
    end

  end
  Doorkeeper = ::Doorkeeper
  Apipie = ::Apipie
end
