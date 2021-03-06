module BeachApiCore
  class V1::JobsController < BeachApiCore::V1::BaseController
    include JobsDoc
    include BeachApiCore::Concerns::V1::ResourceConcern

    prepend_before_action :explicit_application_with_user_authorize!

    resource_description do
      name I18n.t('activerecord.models.beach_api_core/job.other')
    end

    def create
      result = JobCreate.call(params: job_params, request: request, application: current_application)
      if result.success?
        render_json_success(result.job, result.status, root: :job)
      else
        render_json_error({ message: result.message }, result.status)
      end
    end

    def show
      authorize @job
      render_json_success(@job, :ok, root: :job)
    end

    def destroy
      authorize @job
      if @job.destroy
        render_json_success(@job, :ok, root: :job)
      else
        render_json_error({ message: @job.errors.full_messages }, :bad_request)
      end
    end

    private

    def job_params
      params.require(:job).permit(:start_at, :every, params: [:method, :uri, :input, headers: {}])
    end
  end
end
