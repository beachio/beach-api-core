module EmailsDoc
  extend Apipie::DSL::Concern
  extend BeachApiCore::Concerns::V1::ApipieResponseConcern

  api :POST, '/emails', I18n.t('api.resource_description.descriptions.emails.send')
  param :email, Hash, required: true do
    param :user_ids, Array, desc: I18n.t('api.resource_description.descriptions.params.array_of_user_ids')
    param :from, String, desc: I18n.t('api.resource_description.descriptions.params.sender_mail')
    param :to, String, desc: I18n.t('api.resource_description.descriptions.params.recipient_emails')
    param :cc, String
    param :subject, String
    param :body, String, desc: I18n.t('api.resource_description.descriptions.params.email_html_body')
    param :plain, String, desc: I18n.t('api.resource_description.descriptions.params.email_plain_text_body')
    param :mailer, String, desc: I18n.t('api.resource_description.descriptions.params.mailer')
    param :template, String, desc: I18n.t('api.resource_description.descriptions.params.template_name')
    param :template_params, Hash, desc: I18n.t('api.resource_description.descriptions.params.template_params')
    param :scheduled_time, Integer, desc: I18n.t('api.resource_description.descriptions.params.email_timestamp')
  end
  header 'AUTHORIZATION', 'application_id application_uid, client_secret application_secret', required: true
  def create; end
end
