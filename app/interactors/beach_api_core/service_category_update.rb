class BeachApiCore::ServiceCategoryUpdate
  include Interactor

  def call
    if context.service_category.update context.params
      context.status = :ok
    else
      context.status = :bad_request
      context.fail! message: context.service_category.errors.full_messages
    end
  end
end
