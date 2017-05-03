env :PATH, ENV['PATH']

every 30.minutes do
  runner 'BeachApiCore::Job.perform_cron'
end
