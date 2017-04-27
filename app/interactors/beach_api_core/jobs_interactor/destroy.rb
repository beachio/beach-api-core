module BeachApiCore
  class JobsInteractor::Destroy
    include Interactor

    def call
      if context.job.destroy
        context.status = :ok
      else
        context.status = :bad_request
        context.fail! message: context.job.errors.full_messages
      end
    end
  end
end
