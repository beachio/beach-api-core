module BeachApiCore
  class DeviceScore < ActiveRecord::Base
    belongs_to :application, class_name: "Doorkeeper::Application"
    belongs_to :device, class_name: "BeachApiCore::Device"

    attr_readonly :application_id, :device_id

    validates :device, :application, presence: true
    validates :device, uniqueness: { scope: :application }
    after_save :send_broadcast_message, :check_and_create_reward, if: -> {scores_changed?}

    def send_broadcast_message
      BeachApiCore::DeviceChannel.broadcast_to(device, payload: {event: "devicePointsChanged", value: self.scores, message: "Your scores for #{application.name} was changed."})
    end

    def check_and_create_reward
      achievement = BeachApiCore::Achievement.where(:application_id =>  self.application_id, :mode_type => "BeachApiCore::WebhookConfig", :available_for => 'devices').first
      BeachApiCore::Reward.new(:achievement => achievement, reward_to: device).save if !achievement.nil? && self.scores > achievement.points_required
    end
  end
end
