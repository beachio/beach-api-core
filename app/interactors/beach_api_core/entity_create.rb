class BeachApiCore::EntityCreate
  include Interactor

  def call
    context.entity = context.user.entities.build(context.params)
    if context.entity.save
      context.status = :ok
    else
      context.status = :bad_request
      context.fail! message: context.entity.errors.full_messages
    end
  end
end
