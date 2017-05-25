module BeachApiCore
  class JobCreate
    include Interactor

    before do
      if context.params[:params] && context.params[:params][:uri]
        url = context.params[:params][:uri]
        url = URI.join(context.request.base_url, context.params[:params][:uri]) unless url =~ %r{\Ahttps?://}
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
