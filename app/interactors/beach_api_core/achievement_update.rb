class BeachApiCore::AchievementUpdate
  include Interactor

  def call
    if context.params['max_rewards'] == '1 per day'
      context.params['max_rewards'] = 0
    elsif context.params['max_rewards'] == '1 per week'
      context.params['max_rewards'] = 1
    elsif context.params['max_rewards'] == '1 per month'
      context.params['max_rewards'] = 2
    elsif context.params['max_rewards'] == 'unlimited'
      context.params['max_rewards'] = 3
    end
    if context.achievement.mode_type == 'BeachApiCore::WebhookConifg'
      context.params.delete(:giftbit_brand_ids)
      context.params.delete(:use_all_config_brands)
    end
    if context.achievement.update context.params
      context.status = :ok
    else
      context.status = :bad_request
      context.fail! message: context.achievement.errors.full_messages
    end
  end
end