class BeachApiCore::InteractionCreate
  include Interactor

  def call
    context.interaction = context.user.interactions.build(context.params)
    if context.interaction.save
      context.status = :ok
    else
      context.status = :bad_request
      context.fail! message: context.interaction.errors.full_messages
    end
  end
end
