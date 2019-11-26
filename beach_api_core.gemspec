$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'beach_api_core/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'beach_api_core'
  s.version     = BeachApiCore::VERSION
  s.authors     = ['Vital Ryabchinskiy', 'Kate Karpycheva']
  s.email       = ['vital.ryabchinskiy@gmail.com']
  s.homepage    = 'https://github.com/beachio/beach-api-core'
  s.summary     = 'Summary of BeachApiCore.'
  s.description = 'Description of BeachApiCore.'
  s.license     = 'MIT'
  s.test_files  = Dir['spec/**/*']

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'rails'

  s.add_dependency 'omniauth'
  s.add_dependency 'doorkeeper', '4.3.2'

  s.add_dependency 'pg'
  s.add_dependency 'baby_squeel'
  s.add_dependency 'pundit'
  s.add_dependency 'active_model_serializers'
  s.add_dependency 'bcrypt'
  s.add_dependency 'versionist'
  s.add_dependency 'refile'
  s.add_dependency 'activerecord_lookup_or_initialize'

  s.add_dependency 'elasticsearch-rails'
  s.add_dependency 'elasticsearch-model'
  s.add_dependency 'sidekiq'
  s.add_dependency 'whenever'
  s.add_dependency 'acts_as_downcasable_on'
  s.add_dependency 'acts_as_strippable_on'

  s.add_dependency 'interactor'
  s.add_dependency 'interactor-rails'

  s.add_dependency 'slim-rails'
  s.add_dependency 'stripe'

  s.add_dependency 'apipie-rails'
  s.add_dependency 'rmagick'

  s.add_dependency 'draper'
  s.add_dependency 'aws-sdk'
  s.add_dependency 'activeadmin'
  s.add_dependency 'paper_trail'
  s.add_dependency 'redis-objects'
  s.add_dependency 'ancestry'
  s.add_dependency 'rack-cors'
  s.add_dependency 'rails-jquery-autocomplete'

  s.add_dependency 'redis', '< 4'
  s.add_dependency 'api-ai-ruby'
end
