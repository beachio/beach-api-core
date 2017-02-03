class BeachApiCore::DoorkeeperInteractor::ApplicationUpdate
  include Interactor

  def call
    if context.application.update context.params
      context.status = :ok
    else
      context.status = :bad_request
      context.fail! message: context.application.errors.full_messages
    end
  end
end
