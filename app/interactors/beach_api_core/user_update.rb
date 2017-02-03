class BeachApiCore::UserUpdate
  include Interactor

  def call
    context.user.profile.keepers = context.keepers
    if context.user.update context.params
      context.status = :ok
    else
      context.status = :bad_request
      context.fail! message: context.user.errors.full_messages
    end
  end
end
