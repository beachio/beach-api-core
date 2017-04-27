module BeachApiCore
  class JobsInteractor::Create
    include Interactor

    before do
      if context.params[:params] && context.params[:params][:uri]
        url = URI.join(context.host, context.params[:params][:uri])
        context.params[:params][:uri] = url.to_s
      end
    end

    def call
      context.job = Job.new(context.params)
      if context.job.save
        context.status = :created
      else
        context.status = :bad_request
        context.fail! message: context.job.errors.full_messages
      end
    end
  end
end
