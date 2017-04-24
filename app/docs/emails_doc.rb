module EmailsDoc
  extend Apipie::DSL::Concern
  extend BeachApiCore::Concerns::V1::ApipieResponseConcern

  api :POST, '/emails', 'Send an email'
  param :email, Hash, required: true do
    param :user_ids, Array
    param :from, String
    param :to, String
    param :cc, String
    param :subject, String
    param :body, String
    param :template, String
    param :scheduled_time, Integer
  end
  header 'AUTHORIZATION', 'application_id application_uid, client_secret application_secret', required: true
  def create
  end
end
