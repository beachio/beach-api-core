class BeachApiCore::AchievementCreate
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
    context.achievement = BeachApiCore::Achievement.new context.params
    context.achievement.application = context.application
    if context.achievement.save
      context.status = :created
    else
      context.status = :bad_request
      context.fail! message: context.achievement.errors.full_messages
    end
  end
end