module BeachApiCore
  class NotificationMailer < ApplicationMailer

    layout 'notification_mailer'

    def daily_notifications
      @user = params[:user]
      @dict = params[:dict]

      mail from: from(:noreply_from), to: @user.email,
           subject: 'Daily notifications'
    end
  end
end
