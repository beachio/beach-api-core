module BeachApiCore
  class NotificationMailer < ApplicationMailer

    layout 'notification_mailer'

    def daily_notifications
      @notifications_by_project = params[:notifications_by_project]

      mail from: 'notifications@beach.io',
           to: params[:email],
           subject: 'Daily notifications'
    end
  end
end
