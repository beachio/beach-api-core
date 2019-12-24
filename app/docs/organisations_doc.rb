module OrganisationsDoc
  extend Apipie::DSL::Concern
  extend BeachApiCore::Concerns::V1::ApipieResponseConcern

  def_param_group :organisation do
    param :organisation, Hash, required: true do
      param :name, String, required: true
      param :logo_properties, Hash
      param :logo_image_attributes, Hash do
        param :file, File, desc: I18n.t('api.resource_description.descriptions.params.postfield_file')
        param :base64, String, desc: I18n.t('api.resource_description.descriptions.params.encoded_string')
      end
    end
  end

  api :GET, '/organisations', I18n.t('api.resource_description.descriptions.organisations.list')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example "\"organisations\": [#{apipie_organisation_response}, ...]"
  def index; end

  api :GET, '/organisations/:id/published_applications', 'List of all published applications'
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example '
  {
    "applications": [
      {
        "id": 17,
        "name": "Test  App",
        "mail_type_band_color": "#0000ff",
        "mail_type_band_text_color": "#ffffff",
        "logo_url": "https://coinstash-platform-development.s3.amazonaws.com/Test%20%20App/2018-09-27%2013%3A49%3A07%20%2B0300%20logo.png"
      }, ...
    ]
  }'
  def published_applications; end

  api :POST, '/organisations', I18n.t('api.resource_description.descriptions.organisations.create')
  param :organisation, Hash, required: true do
    param :name, String, required: true
    param :email, String, required: true, desc: "Organisation's email"
    param :logo_properties, Hash, required: false
    param :logo_image_attributes, Hash, required: false do
      param :file, File, required: false, desc: "Postfield file"
      param :base64, String, required: false, desc: "Encoded Base64 string"
    end
  end
  example "\"organisation\": #{apipie_organisation_response}
          \n#{I18n.t('api.resource_description.fail',
                     description: I18n.t('api.resource_description.fails.errors_description'))}"
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  def create; end

  api :GET, '/organisations/:id', I18n.t('api.resource_description.descriptions.organisations.get')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example "\"organisation\": #{apipie_organisation_response}"
  def show; end

  api :PUT, '/organisations/:id', I18n.t('api.resource_description.descriptions.organisations.update')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param_group :organisation
  example "\"organisation\": #{apipie_organisation_response}
          \n#{I18n.t('api.resource_description.fail',
                     description: I18n.t('api.resource_description.fails.errors_description'))}"
  def update; end

  api :DELETE, '/organisations/:id', I18n.t('api.resource_description.descriptions.organisations.remove')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example I18n.t('api.resource_description.fail',
                 description: I18n.t('api.errors.could_not_remove',
                                     model: I18n.t('activerecord.models.beach_api_core/organisation.downcase')))
  def destroy; end

  api :GET, '/organisations/users', I18n.t('api.resource_description.descriptions.organisations.get_users')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param :term, String, desc: I18n.t('api.resource_description.descriptions.params.term_for_autocomplete')
  param :roles, Array, desc: I18n.t('api.resource_description.descriptions.params.roles')
  example "\"users\": [#{apipie_organisation_user_response}, ...]"
  def users; end

  api :PUT, '/organisations/:id/current', I18n.t('api.resource_description.descriptions.organisations.set_context')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  def current; end

  api :GET, '/organisations/get_current', I18n.t('api.resource_description.descriptions.organisations.get_context')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example "\"organisation\": #{apipie_organisation_response}"
  def get_current; end

  api :GET, 'organisation/:organisation_id/subscription/:id/show_invoices', 'Show invoices subscriptions of organisation'
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example "[
    {
        \"id\": 12,
        \"keeper_type\": \"BeachApiCore::Organisation\",
        \"keeper_id\": 8,
        \"subscription_id\": 14,
        \"invoice_url_link\": \"https://pay.stripe.com/invoice/invst_yHsTACRTbcbf1h1eWvhRR\",
        \"invoice_pdf_link\": \"https://pay.stripe.com/invoice/invst_yHsTACRTbcbf1h1eWvhRR/pdf\",
        \"created_at\": \"2019-12-16T08:22:18.185Z\",
        \"updated_at\": \"2019-12-16T08:22:18.185Z\"
    },
    {...}
]"
  def show_invoices; end
end
