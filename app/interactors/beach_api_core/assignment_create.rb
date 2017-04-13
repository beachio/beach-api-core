class BeachApiCore::AssignmentCreate
  include Interactor

  def call
    context.assignment = context.organisation.assignments.build context.params
    if context.assignment.save
      context.status = :created
    else
      context.status = :bad_request
      context.fail! message: context.assignment.errors.full_messages
    end
  end
end
