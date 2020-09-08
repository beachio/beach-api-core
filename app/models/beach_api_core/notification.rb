module BeachApiCore
  class Notification < ApplicationRecord
    belongs_to :user
    belongs_to :project, class_name: 'VulcanCore::Project'
    enum kind: { email: 0, ws: 1 }
    enum notify_type: {
      create_proj: 0,
      update_proj: 1,
      destroy_proj: 2,
      create_chart: 3,
      update_chart: 4,
      destroy_chart: 5,
      create_organisation: 6
    }

    def dict
      BeachApiCore::Notification
        .where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)
        .where(notify_type: %i(update_proj destroy_proj create_chart update_chart destroy_chart))
        .joins(%i(user project))
        .group_by(&:user)
        .map { |k, v| [k, v.group_by(&:project).map { |i, j| [i, j.group_by(&:notify_type).map { |a, b| [a, b.length] }.to_h]}.to_h]}
        .to_h
        .each do |user, dict|
          BeachApiCore::NotificationMailer.with(user: user, dict: dict).daily_notifications.deliver_now
        end
    end
  end
end
