class BeachApiCore::TeamUpdate
  include Interactor

  def call
    if context.team.update context.params
      context.status = :ok
    else
      context.status = :bad_request
      context.fail! message: context.team.errors.full_messages
    end
  end
end
