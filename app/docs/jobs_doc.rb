module JobsDoc
  extend Apipie::DSL::Concern
  extend BeachApiCore::Concerns::V1::ApipieResponseConcern

  api :POST, '/jobs', 'Create a new job'
  param :job, Hash, required: true do
    param :input, Hash, required: true, desc: 'An array of user ids to send email instead of `to` param'
    param :start_at, DateTime, required: true
  end
  header 'AUTHORIZATION', 'application_id application_uid, client_secret application_secret', required: true
  def create
  end

  api :DELETE, '/jobs/:job_id', 'Destroy an existing job'
  header 'AUTHORIZATION', 'application_id application_uid, client_secret application_secret', required: true
  def destroy
  end
end
