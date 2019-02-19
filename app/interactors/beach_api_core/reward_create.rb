class BeachApiCore::RewardCreate
  include Interactor

  def call
    context.reward = BeachApiCore::Reward.new context.params
    context.reward.reward_to = context.reward_to
    if context.reward.save
      context.status = :created
    else
      context.status = :bad_request
      context.fail! message: context.reward.errors.full_messages
    end
  end
end

