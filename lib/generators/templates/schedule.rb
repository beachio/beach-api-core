every 30.minutes do
  runner 'BeachApiCore::Job.perform_cron'
end
