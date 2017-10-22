class BeachApiCore::UserAccessCreate
  include Interactor

  def call
    context.user_access = context.organisation.user_accesses.build context.params
    if context.user_access.save
      context.status = :created
    else
      context.status = :bad_request
      context.fail! message: context.user_access.errors.full_messages
    end
  end
end
