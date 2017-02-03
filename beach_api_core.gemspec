$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "beach_api_core/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "beach_api_core"
  s.version     = BeachApiCore::VERSION
  s.authors     = ["Vital Ryabchinskiy"]
  s.email       = ["vital.ryabchinskiy@gmail.com"]
  s.homepage    = "https://github.com/beachio/beach-api-core"
  s.summary     = "Summary of BeachApiCore."
  s.description = "Description of BeachApiCore."
  s.license     = "MIT"
  s.test_files  = Dir["spec/**/*"]

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.0.1"

  s.add_development_dependency "bcrypt"
  s.add_development_dependency "sqlite3"
end
