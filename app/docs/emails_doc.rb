module EmailsDoc
  extend Apipie::DSL::Concern
  extend BeachApiCore::Concerns::V1::ApipieResponseConcern

  api :POST, '/emails', 'Send an email'
  param :email, Hash, required: true do
    param :user_ids, Array, desc: 'An array of user ids to send email instead of `to` param'
    param :from, String, desc: 'Sender email'
    param :to, String, desc: 'Recipient emails joined by comma'
    param :cc, String
    param :subject, String
    param :body, String
    param :scheduled_time, Integer, desc: 'Timestamp for sending out an email'
  end
  header 'AUTHORIZATION', 'application_id application_uid, client_secret application_secret', required: true
  def create
  end
end
