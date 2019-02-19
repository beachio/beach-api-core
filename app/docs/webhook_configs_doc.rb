module WebhookConfigsDoc
  extend Apipie::DSL::Concern
  extend BeachApiCore::Concerns::V1::ApipieResponseConcern

  api :GET, '/webhook_configs', I18n.t('api.resource_description.descriptions.webhook_configs.list')
  header 'Authorization', 'Bearer access_token', required: true
  example '
  {
    "webhook_configs": [
      {
        "id": 2,
        "config_name": "test123",
        "request_method": "GET",
        "request_body": "",
        "application": {
          "id": 17,
          "created_at": "2018-07-23T06:26:07.301Z",
          "name": "Test  App",
          "mail_type_band_color": "#0000ff",
          "mail_type_band_text_color": "#ffffff",
          "logo_url": ""
        },
        "webhook_parameters": [
          {
            "id": 4,
            "name": "test_param",
            "value": "test_value"
          }
        ]
      }
    ]
  }'
  def index; end


  api :GET, '/webhook_configs/:id', I18n.t('api.resource_description.descriptions.webhook_configs.get')
  header 'Authorization', 'Bearer access_token', required: true
  example '
  {
    "webhook_config": {
      "id": 2,
      "config_name": "test123",
      "request_method": "GET",
      "request_body": "",
      "application": {
        "id": 17,
        "created_at": "2018-07-23T06:26:07.301Z",
        "name": "Test  App",
        "mail_type_band_color": "#0000ff",
        "mail_type_band_text_color": "#ffffff",
        "logo_url": ""
      },
      "webhook_parameters": [
        {
          "id": 4,
          "name": "test_param",
          "value": "test_value"
        }
      ]
    }
  }'
  def show; end



  api :POST, '/webhook_configs', I18n.t('api.resource_description.descriptions.webhook_configs.create')
  header 'Authorization', 'Bearer access_token', required: true
  param :webhook_config, Hash, required: true do
    param :config_name,     String, required: true
    param :uri,             String, required: true
    param :request_method,  String, required: true, desc: 'Should be one of "GET", "POST", "PUT", "DELETE"'
    param :request_body,    String, required: false
    param :webhook_parameters, Array, of: Hash, required: false do
      param :name, String, required: true
      param :value, String, required: true
    end
  end
  example '
  {
    "webhook_config": {
      "id": 4,
      "config_name": "test webhook",
      "uri": "http://webhook.site",
      "request_method": "GET",
      "request_body": "",
      "application": {
        "id": 17,
        "created_at": "2018-07-23T06:26:07.301Z",
        "name": "Test  App",
        "mail_type_band_color": "#0000ff",
        "mail_type_band_text_color": "#ffffff",
        "logo_url": ""
      },
      "webhook_parameters": [
        {
          "id": 5,
          "name": "test_param",
          "value": "test_value"
        }
      ]
    }
  }'
  def create; end

  api :PUT, '/webhook_configs', I18n.t('api.resource_description.descriptions.webhook_configs.update')
  header 'Authorization', 'Bearer access_token', required: true
  param :webhook_config, Hash, required: true do
    param :config_name,     String, required: false
    param :uri,             String, required: false
    param :request_method,  String, required: false, desc: 'Should be one of "GET", "POST", "PUT", "DELETE"'
    param :request_body,    String, required: false
    param :webhook_parameters, Array, of: Hash, required: false do
      param :id, Integer, required: false
      param :name, String, required: false
      param :value, String, required: false
    end
  end
  example '
  {
    "webhook_config": {
      "id": 4,
      "config_name": "test123",
      "uri": "http://test123.com",
      "request_method": "GET",
      "request_body": "",
      "application": {
        "id": 17,
        "created_at": "2018-07-23T06:26:07.301Z",
        "name": "Test  App",
        "mail_type_band_color": "#0000ff",
        "mail_type_band_text_color": "#ffffff",
        "logo_url": ""
      },
      "webhook_parameters": [
        {
          "id": 6,
          "name": "test_param",
          "value": "test_value"
        },
        {
          "id": 7,
          "name": "test2",
          "value": "value2"
        }
      ]
    }
  }'
  def update; end

  api :DELETE, '/webhook_configs/:id', I18n.t('api.resource_description.descriptions.webhook_configs.delete')
  header 'Authorization', 'Bearer access_token', required: true
  example I18n.t('api.resource_description.fail',
                 description: I18n.t('api.errors.could_not_remove',
                                     model: I18n.t('activerecord.models.beach_api_core/webhook_config.downcase')))
  def destroy; end

  api :DELETE, '/webhook_configs/:id/remove_parameter/:parameter_id', I18n.t('api.resource_description.descriptions.webhook_configs.remove')
  header 'Authorization', 'Bearer access_token', required: true
  example I18n.t('api.resource_description.fail',
                 description: I18n.t('api.errors.could_not_remove',
                                     model: I18n.t('activerecord.models.beach_api_core/webhook_config.webhook_parametr')))
  def remove_brand_from_config; end

end
