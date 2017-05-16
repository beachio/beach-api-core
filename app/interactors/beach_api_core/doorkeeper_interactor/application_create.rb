class BeachApiCore::DoorkeeperInteractor::ApplicationCreate
  include Interactor

  def call
    context.application = context.user.applications.build(context.params)
    if context.application.save
      context.status = :created
    else
      context.status = :bad_request
      context.fail! message: context.application.errors.full_messages
    end
  end
end
