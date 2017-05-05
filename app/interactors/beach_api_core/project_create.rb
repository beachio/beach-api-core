module BeachApiCore
  class ProjectCreate
    include Interactor

    def call
      context.project = context.organisation.projects.build(context.params)
      context.project.assign_attributes(user: context.user)

      if context.project.save
        context.status = :created
      else
        context.status = :bad_request
        context.fail! message: context.project.errors.full_messages
      end
    end
  end
end
