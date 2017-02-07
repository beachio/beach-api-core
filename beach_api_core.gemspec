$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "beach_api_core/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'beach_api_core'
  s.version     = BeachApiCore::VERSION
  s.authors     = ['Vital Ryabchinskiy']
  s.email       = ['vital.ryabchinskiy@gmail.com']
  s.homepage    = 'https://github.com/beachio/beach-api-core'
  s.summary     = 'Summary of BeachApiCore.'
  s.description = 'Description of BeachApiCore.'
  s.license     = 'MIT'
  s.test_files  = Dir['spec/**/*']

  s.files = Dir['{app,config,db,lib}/**/*', "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.0.1"

  s.add_dependency "omniauth", "~> 1.3.2"
  s.add_dependency "doorkeeper", "~> 4.2.0"

  s.add_dependency "pg"
  s.add_dependency "baby_squeel", "~> 1.0.1"
  s.add_dependency "pundit", "~> 1.1.0"
  s.add_dependency "active_model_serializers", "~> 0.10.4"
  s.add_dependency "bcrypt", "~> 3.1.11"
  s.add_dependency "versionist", "~> 1.5.0"
  s.add_dependency "refile"

  s.add_dependency "interactor", "~> 3.1.0"
  s.add_dependency "interactor-rails", "~> 2.0.2"

  s.add_dependency "slim-rails", "~> 3.1.1"
end
