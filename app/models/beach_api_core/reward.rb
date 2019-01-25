module BeachApiCore
  class Reward < ActiveRecord::Base
    belongs_to :achievement, class_name: "BeachApiCore::Achievement"
    belongs_to :reward_to, polymorphic: true
    belongs_to :giftbit_brand, class_name: "BeachApiCore::GiftbitBrand"
    before_create :check_on_confirm_required
    validate :check_on_max_rewards, :check_object,  on: [:create]
    before_save    :return_points, if: -> { status_changed? && Closed? && return_user_points && (status_was == 'Pending' || status_was == 'Fulfilled') }
    before_destroy :return_points, if: -> { Pending? || Fulfilled? }
    scope :pending, -> { where(status: 'Pending', confirmed: true) }
    validate :check_status, on: [:update], if: -> {giftbit_brand_id_changed? && reward_to_changed?}
    validate :check_brand_for_achievement, on: :create
    after_save :start_webhook_worker
    before_destroy :close_reward
    attr_accessor :return_user_points
    enum status: {
        "Pending": 0,
        "Fulfilled": 1,
        "Closed": 2,
        "Spent": 3
    }

    attr_readonly :achievement_id, :reward_to_id, :reward_to_type, :giftbit_brand_id

    def update_status status
      case status
        when 'GIVER_CANCELLED', 'EXPIRED'
          self.update_attributes(status: 'Closed', return_user_points: true)
        when 'REDEEMED'
          self.update_attribute(:status, 'Closed')
        when 'SENT_AND_REDEEMABLE'
          self.update_attribute(:status, 'Fulfilled')
        else
          status
      end
    end

    def check_brand_for_achievement
      if !self.giftbit_brand_id.blank? && self.achievement.mode_type == 'BeachApiCore::GiftbitConfig'
         if self.achievement.use_all_config_brands
           brands = self.achievement.mode.giftbit_brands.pluck(:id)
           self.errors.add :giftbit_brand_id, "Wrong Brand" unless brands.include?(self.giftbit_brand_id)
         else
           self.errors.add :giftbit_brand_id, "Wrong Brand" unless self.achievement.giftbit_brands.pluck(:id).include?(self.giftbit_brand_id)
         end
      end
    end

    def send_broadcast
      reward_to_type.match?(/User/) ? send_broadcast_message_to_user("achievementAwarded", "You get the Reward", "Reward Fullfiled", "You get the reward") :
          send_broadcast_message_to_device("achievementAwarded", "You get the Reward", "Reward Fullfiled", "You get the reward") if self.achievement.notify_via_broadcasts
    end


    def send_email_notification(type)
      BeachApiCore::WebhookRewardMailer.reward_achieved(self.achievement.application, self.reward_to).deliver_later if self.achievement.notify_by_email &&
          self.reward_to_type.match?(/User/)&& type == "webhook"
    end

    private
    def check_on_confirm_required
      self.confirmed = true unless  self.achievement.reward_issue_requires_approval
    end

    def close_reward
      if self.status == 'Fulfilled' && self.achievement.mode_type == 'BeachApiCore::GiftbitConfig'
        token =  self.achievement.mode.giftbit_token.blank? ? ENV['GIFTBIT_TOKEN'] : self.achievement.mode.giftbit_token.blank?
        BeachApiCore::GiftbitHelper.cancel_gift(token, self.gift_uuid)
      end
    end

    def check_object
      return unless self.errors.blank?
      scores = reward_to.scores.find_by(:application_id => self.achievement.application.id)
      if scores.nil? || scores.scores < self.achievement.points_required
        self.errors.add :reward_to, "Not enough scores to get this reward"
      elsif (self.achievement.available_for == 'users' ) && !self.reward_to_type.match?(/User/)  ||
            (self.achievement.available_for == 'devices') && !self.reward_to_type.match?(/Device/)
        self.errors.add :wrong_reward_to, 'Invalid object for indicated achievement'
      else

        scores.update_columns(scores: scores.scores - achievement.points_required)
        self.reward_to_type.match?(/User/) ? send_broadcast_message_to_user(nil, 'Scores was changed', "rewardCreated", "Successful reward request") :
            send_broadcast_message_to_device(nil, "Scores for #{self.achievement.application.name} was changed." ,"rewardCreated", "Successful reward request") if self.achievement.notify_via_broadcasts
      end
    end

    def return_points
      object_scores = self.reward_to.scores.find_by(:application_id => self.achievement.application)
      unless object_scores.nil?
        object_scores.update_columns(scores: object_scores.scores + self.achievement.points_required)
        self.reward_to_type.match?(/User/) ? send_broadcast_message_to_user(nil, 'Scores was changed', "rewardClosed", "Gift was canceled or expired.") :
            send_broadcast_message_to_device(nil, "Scores for #{self.achievement.application.name} was changed." ,"rewardClosed", "Gift was canceled or expired.") if self.achievement.notify_via_broadcasts
      end
    end

    def send_broadcast_message_to_user(event = nil, message = nil, reason = nil, reason_message = nil)
      broadcast_message("BeachApiCore::UserChannel", "user", reason.nil? ? "rewardClosed" : reason,
                        reason_message.nil? ? 'Gift was cancelled or expired' : reason_message, event, message)
    end

    def send_broadcast_message_to_device(event = nil, message = nil, reason = nil, reason_message = nil)
      broadcast_message("BeachApiCore::DeviceChannel", "device", reason.nil? ? "rewardClosed" : reason,
                        reason_message.nil? ? 'Gift was cancelled or expired' : reason_message, event, message)
    end

    def broadcast_message(channel, object, reason, reason_message, event = nil, message = nil)
      channel.constantize.broadcast_to(object == 'user' ? self.reward_to.find_or_create_application_token(self.achievement.application) : self.reward_to,
                                       payload: {
                                           event: event.nil? ? "#{object}PointsChanged" : event, value: self.reward_to.scores.find_by(:application_id => self.achievement.application.id).scores,
                                           message: message,
                                           reason: reason,
                                           reason_message: reason_message })
    end

    def check_status
      self.errors.add :error, "Reward_to can't be changed"
    end

    def start_webhook_worker
      BeachApiCore::WebhookRewardTypeWorker.perform_in(15.seconds.from_now, self.id) if self.achievement.mode_type == 'BeachApiCore::WebhookConfig' && self.status == 'Pending' && self.confirmed
    end

    def check_on_max_rewards
      return unless self.errors.blank?
      unless self.achievement.max_rewards == 'unlimited'
        case self.achievement.max_rewards
          when '1 per day'
            days = 1
          when '1 per week'
            days = 7
          else
            days = 31
        end
        last_reward = self.reward_to.rewards.where(achievement_id: self.achievement_id).last
        self.errors.add :achievement, "You can get reward only #{self.achievement.max_rewards}" if !last_reward.nil? && ((Time.now - last_reward.created_at).to_f / 1.day) <= days
      end
    end

  end
end
