module JobsDoc
  extend Apipie::DSL::Concern
  extend BeachApiCore::Concerns::V1::ApipieResponseConcern

  api :POST, '/jobs', 'Create a new job'
  param :job, Hash, required: true do
    param :input, Hash, required: true, desc: 'An array of user ids to send email instead of `to` param'
    param :start_at, DateTime, required: true
  end
  header 'AUTHORIZATION', 'application_id application_uid, client_secret application_secret', required: true
  example "\"job\": #{apipie_job_response}"
  def create
  end

  api :GET, '/job/:id', 'Show an existing job'
  header 'AUTHORIZATION', 'application_id application_uid, client_secret application_secret', required: true
  example "\"job\": #{apipie_job_response}"
  def show
  end

  api :DELETE, '/jobs/:id', 'Destroy an existing job'
  header 'AUTHORIZATION', 'application_id application_uid, client_secret application_secret', required: true
  example "\"job\": #{apipie_job_response}"
  def destroy
  end
end
