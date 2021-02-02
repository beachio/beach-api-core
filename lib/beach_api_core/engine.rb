require 'versionist'
require 'doorkeeper'
# require 'baby_squeel'
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
require 'rails-jquery-autocomplete'
require 'engine_store'
require 'paper_trail'
require 'rack/cors'

module BeachApiCore
  # Mailer actions that could be used to send emails
  mattr_accessor :allowed_mailer_actions
  # Company name, use in mailers
  mattr_accessor :company_names

  def self.configure
    @@allowed_mailer_actions ||= []
    @@company_names = { short: 'BeachApi', long: 'BeachApiCore' }

    yield self if block_given?
  end

  class Engine < ::Rails::Engine
    isolate_namespace BeachApiCore
    class << self
      attr_accessor :elasticsearch_enabled
    end

    initializer :beach_api_core do
      if defined?(ActiveAdmin)
        models = File.join(config.root, 'lib', 'admin')
        ActiveAdmin.application.load_paths.push(models) unless ActiveAdmin.application.load_paths.include?(models)

        views = File.join(config.root, 'lib', 'active_admin', 'views')
        ActiveAdmin.application.load_paths.push(views) unless ActiveAdmin.application.load_paths.include?(views)
      end
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
