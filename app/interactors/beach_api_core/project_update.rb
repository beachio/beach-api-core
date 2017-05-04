module BeachApiCore
  class ProjectUpdate
    include Interactor

    def call
      if context.project.update context.params
        context.status = :ok
      else
        context.status = :bad_request
        context.fail! message: context.project.errors.full_messages
      end
    end
  end
end
