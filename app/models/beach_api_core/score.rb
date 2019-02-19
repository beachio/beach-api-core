module BeachApiCore
  class Score < ApplicationRecord
    belongs_to :application, :class_name => 'Doorkeeper::Application'
    belongs_to :user, :class_name => "BeachApiCore::User"
    attr_readonly :application_id, :user_id

    validates :user, :application, presence: true
    validates :user, uniqueness: { scope: :application }
    after_save :send_broadcast_message, :check_and_create_reward

    SCORES_MESSAGE = "Your scores was changed."

    def send_broadcast_message
      token = Doorkeeper::AccessToken.find_by(:resource_owner_id => user.id, :application_id => application.id)
      unless token.nil?
        application_message = BeachApiCore::Setting.scores_changed_message(keeper: token.application).nil? ? BeachApiCore::Setting.scores_changed_message(keeper: BeachApiCore::Instance.current) : BeachApiCore::Setting.scores_changed_message(keeper: token.application)
        BeachApiCore::UserChannel.broadcast_to(token, payload: {event: "userPointsChanged", value: self.scores, message: application_message.nil? ? SCORES_MESSAGE : application_message},
                                               "user" => BeachApiCore::UserSerializer.new(user, root: :user, current_user: user,  current_application: application))
      end
    end

    def check_and_create_reward
      achievement = BeachApiCore::Achievement.where(:application_id =>  self.application_id, :mode_type => "BeachApiCore::WebhookConfig", :available_for => 'users').first
      BeachApiCore::Reward.new(:achievement => achievement, reward_to: user).save if !achievement.nil? && self.scores > achievement.points_required
    end
  end
end
