class BeachApiCore::ServiceCategoryCreate
  include Interactor

  def call
    context.service_category = BeachApiCore::ServiceCategory.new(context.params)
    if context.service_category.save
      context.status = :created
    else
      context.status = :bad_request
      context.fail! message: context.service_category.errors.full_messages
    end
  end
end
