namespace :beach_api_core do
  namespace :jobs do
    desc 'Add Jobs API cron configuration file to main app'
    task :cron_init do
      source = File.join(Gem.loaded_specs['beach_api_core'].full_gem_path,
                         'lib', 'generators', 'templates', 'schedule.rb')
      target = Rails.root.join('config', 'schedule.rb')
      copy_file source, target
      puts `whenever --update-crontab`
    end
  end
end
