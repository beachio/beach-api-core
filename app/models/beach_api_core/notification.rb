module BeachApiCore
  class Notification < ApplicationRecord
    belongs_to :user
    belongs_to :project, class_name: 'VulcanCore::Project'
    enum kind: { email: 0, ws: 1 }
    enum notify_type: {
      create_project: 0,
      update_project: 1,
      destroy_project: 2,
      create_chart: 3,
      update_chart: 4,
      destroy_chart: 5,
      create_organisation: 6
    }

    def self.mailing
      self
      .where(kind: 'email')
      .joins(%i(user project))
      .group_by(&:user).transform_values do |user|
        user.group_by(&:project).transform_values do |project|
          project.group_by(&:notify_type).transform_values &:length
        end
      end
      .each do |user, dict|
        BeachApiCore::NotificationMailer.with(user: user, dict: dict).daily_notifications.deliver_now!
      end
    end
  end
end
