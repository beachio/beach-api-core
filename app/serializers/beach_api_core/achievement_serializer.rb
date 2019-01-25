module BeachApiCore
  class AchievementSerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern
    include BeachApiCore::Concerns::OptionSerializerConcern

    acts_as_abs_doc_id
    acts_with_options(:current_user)
    attributes :id, :achievement_name, :points_required, :max_rewards, :available_for, :reward_expiry,
               :reward_issue_requires_approval, :notify_by_email, :mode_type, :mode_id,
               :notify_via_broadcasts, :reward_can_be_claimed
    attribute :achievement_brands, if: :condition
    attribute :use_all_config_brands, if: :all_brands

    def reward_can_be_claimed
      return false unless current_user
      if !current_user.scores.find_by(:application => object.application).nil? && object.points_required < current_user.scores.find_by(:application => object.application).scores &&
          (object.available_for == 'users' || object.available_for == 'users and devices')
        if object.max_rewards == 'unlimited'
          return true
        else
          case object.max_rewards
            when '1 per day'
              days = 1
            when '1 per week'
              days = 7
            else
              days = 31
          end
          last_reward = object.rewards.where(reward_to_type: "BeachApiCore::User", reward_to_id: current_user.id).last
          if last_reward.nil? || ((Time.now - last_reward.created_at).to_f / 1.day) > days
            return true
          end
        end
      end
      false
    end


    def mode_type
      object.mode_type.gsub("BeachApiCore::", "")
    end

    def condition
      object.mode_type == "BeachApiCore::GiftbitConfig" && !object.use_all_config_brands
    end

    def all_brands
      object.mode_type == "BeachApiCore::GiftbitConfig" && object.use_all_config_brands
    end

    def achievement_brands
      object.giftbit_brands
    end
  end
end