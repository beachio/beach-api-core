module JobsDoc
  extend Apipie::DSL::Concern
  extend BeachApiCore::Concerns::V1::ApipieResponseConcern

  api :POST, '/jobs', t('api.resource_description.descriptions.jobs.create')
  param :job, Hash, required: true do
    param :params, Hash, required: true do
      param :bearer, String, required: true, desc: t('api.resource_description.descriptions.params.users_access_token')
      param :method, %w(GET POST PUT PATCH DELETE), required: true
      param :url, String, required: true, desc: t('api.resource_description.descriptions.params.relative_request_path')
      param :input, Hash, desc: t('api.resource_description.descriptions.params.post_put_patch_request_params')
    end
    param :start_at, DateTime
    param :every, String, desc: t('api.resource_description.descriptions.params.cron_schedule')
  end
  header 'AUTHORIZATION', 'application_id application_uid, client_secret application_secret', required: true
  example "\"job\": #{apipie_job_response}"
  def create
  end

  api :GET, '/job/:id', t('api.resource_description.descriptions.jobs.show')
  header 'AUTHORIZATION', 'application_id application_uid, client_secret application_secret', required: true
  example "\"job\": #{apipie_job_response}"
  def show
  end

  api :DELETE, '/jobs/:id', t('api.resource_description.descriptions.jobs.destroy')
  header 'AUTHORIZATION', 'application_id application_uid, client_secret application_secret', required: true
  example "\"job\": #{apipie_job_response}"
  def destroy
  end
end
