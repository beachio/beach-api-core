module BeachApiCore
  class V1::JobsController < BeachApiCore::V1::BaseController
    include JobsDoc
    include BeachApiCore::Concerns::V1::ResourceConcern

    resource_description do
      name 'Jobs'
    end

    def create
      result = JobsInteractor::Submit.call(
        params: job_params, headers: request.headers['HTTP_AUTHORIZATION']
      )
      if result.success?
        render_json_success(result.job, result.status, root: :job)
      else
        render_json_error({ message: result.message }, result.status)
      end
    end

    def show
      # @todo: check application auth headers
      render_json_success(@job, :ok, root: :job)
    end

    def destroy
      result = JobsInteractor::Cancel.call(
        job: @job, headers: request.headers['HTTP_AUTHORIZATION']
      )
      if result.success?
        render_json_success(result.job, result.status, root: :job)
      else
        render_json_error({ message: result.message }, result.status)
      end
    end

    private

    def job_params
      params.require(:job).permit(:params, :start_at)
    end
  end
end
