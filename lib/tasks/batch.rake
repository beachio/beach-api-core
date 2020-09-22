namespace :batch do
  desc 'Send daily notify'
  task send_messages: :environment do
    BeachApiCore::Notification.mailing
  end
end
