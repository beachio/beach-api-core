module BeachApiCore
  class V1::JobsController < BeachApiCore::V1::BaseController
    include JobsDoc

    resource_description do
      name 'Jobs'
    end

    def create
      result = JobsInteractor::Submit.call(
        { params: job_params }.merge(headers: request.headers['HTTP_AUTHORIZATION'])
      )
      if result.success?
        render_json_success({ message: 'Email has been created' }, :created)
      else
        render_json_error({ message: result.message }, result.status)
      end
    end

    def destroy

    end

    private

    def job_params
      params.require(:job).permit(:params, :start_at)
    end
  end
end
