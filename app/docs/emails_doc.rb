module EmailsDoc
  extend Apipie::DSL::Concern
  extend BeachApiCore::Concerns::V1::ApipieResponseConcern

  api :POST, '/emails', t('api.resource_description.descriptions.emails.send')
  param :email, Hash, required: true do
    param :user_ids, Array, desc: t('api.resource_description.descriptions.params.array_of_user_ids')
    param :from, String, desc: t('api.resource_description.descriptions.params.sender_mail')
    param :to, String, desc: t('api.resource_description.descriptions.params.recipient_emails')
    param :cc, String
    param :subject, String
    param :body, String, desc: t('api.resource_description.descriptions.params.email_html_body')
    param :plain, String, desc: t('api.resource_description.descriptions.params.email_plain_text_body')
    param :scheduled_time, Integer, desc: t('api.resource_description.descriptions.params.email_timestamp')
  end
  header 'AUTHORIZATION', 'application_id application_uid, client_secret application_secret', required: true
  def create
  end
end
