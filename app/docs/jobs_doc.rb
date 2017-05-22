module JobsDoc
  extend Apipie::DSL::Concern
  extend BeachApiCore::Concerns::V1::ApipieResponseConcern

  api :POST, '/jobs', 'Create a new job'
  param :job, Hash, required: true do
    param :params, Hash, required: true do
      param :bearer, String, required: true, desc: "User's access token"
      param :method, %w(GET POST PUT PATCH DELETE), required: true
      param :url, String, required: true, desc: 'Relative request path'
      param :input, Hash, desc: 'POST, PUT, PATCH request params'
    end
    param :start_at, DateTime
    param :every, String, desc: 'Cron schedule for a job in format "30.minutes", "1.hour", "2.days", etc. Min period is 30 minutes.'
  end
  header 'AUTHORIZATION', 'application_id application_uid, client_secret application_secret', required: true
  example "\"job\": #{apipie_job_response}"
  def create; end

  api :GET, '/job/:id', 'Show an existing job'
  header 'AUTHORIZATION', 'application_id application_uid, client_secret application_secret', required: true
  example "\"job\": #{apipie_job_response}"
  def show; end

  api :DELETE, '/jobs/:id', 'Destroy an existing job'
  header 'AUTHORIZATION', 'application_id application_uid, client_secret application_secret', required: true
  example "\"job\": #{apipie_job_response}"
  def destroy; end
end
