namespace :beach_api_core do
  desc 'Create basic data'
  task :seed => :environment do
    BeachApiCore::Engine.load_seed
  end
end
