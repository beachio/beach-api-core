module MailBodiesDoc
  extend Apipie::DSL::Concern
  extend BeachApiCore::Concerns::V1::ApipieResponseConcern

  api :GET, '/mail_bodies', I18n.t('api.resource_description.descriptions.mail_bodies.list')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example "\"mail_bodies\": #{apipie_mail_body_response}"
  def index; end

  api :GET, '/mail_bodies/:id',  I18n.t('api.resource_description.descriptions.mail_bodies.get')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example "\"application\": #{apipie_mail_body_response}"
  def show; end

  api :POST, '/mail_bodies', I18n.t('api.resource_description.descriptions.mail_bodies.create')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param :mail_body, Hash, required: true do
    param :mail_type, String, desc: 'Mail type ("invitation", "confirm_account", "forgot_password"")', required: true
    param :text_color, String, required: false, desc: "valid CSS hex color code"
    param :button_color, String, required: false, desc: "valid CSS hex color code"
    param :button_text_color, String, required: false, desc: "valid CSS hex color code"
    param :button_text, String, required: false
    param :body_text, String, required: false
    param :greetings_text, String, required: false
    param :signature_text, String, required: false
    param :footer_text, String, required: false
  end
  example "\"mail_body\": #{apipie_mail_body_response}
          \n#{I18n.t('api.resource_description.fail',
                     description: I18n.t('api.errors.could_not_remove',
                                         model: I18n.t('activerecord.models.beach_api_core/mail_body.downcase')))}"
  def create; end

  api :PUT, '/mail_bodies/:id', I18n.t('api.resource_description.descriptions.mail_bodies.update')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param :mail_body, Hash, required: true do
    param :mail_type, String, desc: 'Mail type ("invitation", "confirm_account", "forgot_password"")', required: true
    param :text_color, String, required: false, desc: "valid CSS hex color code"
    param :button_color, String, required: false, desc: "valid CSS hex color code"
    param :button_text_color, String, required: false, desc: "valid CSS hex color code"
    param :button_text, String, required: false
    param :body_text, String, required: false
    param :greetings_text, String, required: false
    param :signature_text, String, required: false
    param :footer_text, String, required: false
  end
  example "\"mail_body\": #{apipie_mail_body_response}
          \n#{I18n.t('api.resource_description.fail',
                     description: I18n.t('api.errors.could_not_remove',
                                         model: I18n.t('activerecord.models.beach_api_core/mail_body.downcase')))}"
  def update; end

  api :DELETE, '/mail_bodies/:id', I18n.t('api.resource_description.descriptions.mail_bodies.delete')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example I18n.t('api.resource_description.fail',
                 description: I18n.t('api.errors.could_not_remove',
                                     model: I18n.t('activerecord.models.beach_api_core/mail_body.downcase')))
  def destroy; end

end
