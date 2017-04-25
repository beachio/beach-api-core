module BeachApiCore
  class JobsInteractor::Create
    include Interactor

    def call
      context.job = Job.new(context.params)
      if context.job.save
        context.status = :created
      else
        context.status = :bad_request
        context.fail! message: context.atom.errors.full_messages
      end
    end
  end
end
