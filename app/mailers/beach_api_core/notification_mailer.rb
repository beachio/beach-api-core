module BeachApiCore
  class NotificationMailer < ApplicationMailer

    layout 'notification_mailer'

    def daily_notifications
      @user = params[:user]
      @application = @user.applications.first
      mail from: 'danespamblyat@yandex.ru', to: 'rozanov61@ya.ru',
           subject: 'Its without footer'
    end

    def dict
      BeachApiCore::Notification
        .where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)
        .joins(:user)
        .group_by(&:user)
        .map { |k, v| [k, v.group_by(&:notify_type).map { |a, b| [a, b.length] }.to_h] }
        .to_h
    end
  end
end
