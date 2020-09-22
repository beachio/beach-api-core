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
      notifications = BeachApiCore::Notification.where(kind: 'email', sent: false)
      user_ids = notifications.map(&:user_id).uniq
      project_ids = notifications.map(&:project_id).uniq
      users = BeachApiCore::User.where(id: user_ids).map {|u| [u.id, u.email]}.to_h
      projects = VulcanCore::Project.where(id: project_ids).map {|p| [p.id, p.name]}.to_h

      notifications.inject({}) do |memo, n| 
        user = users[n.user_id]
        project = projects[n.project_id]

        memo[user] ||= {}
        memo[user][project] ||= {}
        memo[user][project][n.notify_type] ||= 0
        memo[user][project][n.notify_type] += 1
        memo
      end.each do |email, notifications_by_project|
        BeachApiCore::NotificationMailer.with(email: email, notifications_by_project: notifications_by_project).daily_notifications.deliver_now!
      end
    end
  end
end
