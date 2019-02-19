module GiftbitConfigsDoc
  extend Apipie::DSL::Concern
  extend BeachApiCore::Concerns::V1::ApipieResponseConcern

  api :GET, '/giftbit_configs', I18n.t('api.resource_description.descriptions.giftbit_configs.list')
  header 'Authorization', 'Bearer access_token', required: true
  example '
  {
    "giftbit_configs": [
      {
        "id": 4,
        "config_name": "test_name",
        "email_to_notify": "",
        "application": {
          "id": 17,
          "created_at": "2018-07-23T06:26:07.301Z",
          "name": "Test  App",
          "mail_type_band_color": "#0000ff",
          "mail_type_band_text_color": "#ffffff",
          "logo_url": ""
        },
        "giftbit_brands": [
          {
            "id": 6,
            "gift_name": "$15 XBOX GIFT CARD",
            "amount": 1500,
            "brand_code": "amazonus",
            "giftbit_email_template": "",
            "email_subject": "test",
            "email_body": "test1"
          },
          {
            "id": 7,
            "gift_name": "$10 playstation Gift Card",
            "amount": 1000,
            "brand_code": "walmart",
            "giftbit_email_template": "Playstation_template_id",
            "email_subject": "",
            "email_body": ""
          }
        ]
      }
    ]
  }'
  def index; end


  api :GET, '/giftbit_configs/:id', I18n.t('api.resource_description.descriptions.giftbit_configs.get')
  header 'Authorization', 'Bearer access_token', required: true
  example '
  {
    "giftbit_config": {
      "id": 4,
      "config_name": "test_name",
      "email_to_notify": "",
      "application": {
        "id": 17,
        "created_at": "2018-07-23T06:26:07.301Z",
        "name": "Test  App",
        "mail_type_band_color": "#0000ff",
        "mail_type_band_text_color": "#ffffff",
        "logo_url": ""
      },
      "giftbit_brands": [
        {
          "id": 6,
          "gift_name": "$15 XBOX GIFT CARD",
          "amount": 1500,
          "brand_code": "amazonus",
          "giftbit_email_template": "",
          "email_subject": "test",
          "email_body": "test1"
        },
        {
          "id": 7,
          "gift_name": "$10 playstation Gift Card",
          "amount": 1000,
          "brand_code": "walmart",
          "giftbit_email_template": "Playstation_template_id",
          "email_subject": "",
          "email_body": ""
        }
      ]
    }
  }'
  def show; end



  api :POST, '/giftbit_configs', I18n.t('api.resource_description.descriptions.giftbit_configs.create')
  header 'Authorization', 'Bearer access_token', required: true
  param :giftbit_config, Hash, required: true do
    param :config_name,     String, required: true
    param :giftbit_token,          String, required: false
    param :email_to_notify,        String, required: false
    param :giftbit_brands_attributes, Array, of: Hash, required: true do
      param :gift_name, String, required: true
      param :brand_code, String, required: true
      param :amount, Integer, required: true
      param :giftbit_email_template, String, required: false
      param :email_subject, String, required: false
      param :email_body, String, required: false
    end
  end
  example '
  {
    "giftbit_config": {
      "id": 5,
      "config_name": "TEst API",
      "email_to_notify": null,
      "application": {
        "id": 17,
        "created_at": "2018-07-23T06:26:07.301Z",
        "name": "Test  App",
        "mail_type_band_color": "#0000ff",
        "mail_type_band_text_color": "#ffffff",
        "logo_url": ""
      },
      "giftbit_brands": [
        {
          "id": 8,
          "gift_name": "$5 walmart Gift Card",
          "amount": 500,
          "brand_code": "walmart",
          "giftbit_email_template": "Test template",
          "email_subject": null,
          "email_body": null
        },
        {
          "id": 9,
          "gift_name": "$10 amozonus api2 card",
          "amount": 1000,
          "brand_code": "amazonus",
          "giftbit_email_template": "Test template2",
          "email_subject": null,
          "email_body": null
        }
      ]
    }
  }'
  def create; end

  api :PUT, '/giftbit_configs/:id', I18n.t('api.resource_description.descriptions.giftbit_configs.update')
  header 'Authorization', 'Bearer access_token', required: true
  param :giftbit_config, Hash, required: true do
    param :config_name,     String, required: false
    param :giftbit_token,          String, required: false
    param :email_to_notify,        String, required: false
    param :giftbit_brands_attributes, Array, of: Hash, required: true do
      param :id,          Integer,required: false
      param :gift_name,   String, required: false
      param :brand_code,  String, required: false
      param :amount,      Integer, required: false
      param :giftbit_email_template, String, required: false
      param :email_subject, String, required: false
      param :email_body,  String, required: false
    end
  end
  example '
  {
    "giftbit_config": {
      "id": 5,
      "config_name": "TEst API",
      "email_to_notify": null,
      "application": {
        "id": 17,
        "created_at": "2018-07-23T06:26:07.301Z",
        "name": "Test  App",
        "mail_type_band_color": "#0000ff",
        "mail_type_band_text_color": "#ffffff",
        "logo_url": ""
      },
      "giftbit_brands": [
        {
          "id": 8,
          "gift_name": "$5 walmart Gift Card",
          "amount": 500,
          "brand_code": "walmart",
          "giftbit_email_template": "Test template",
          "email_subject": null,
          "email_body": null
        },
        {
          "id": 9,
          "gift_name": "$10 amozonus api2 card",
          "amount": 1000,
          "brand_code": "amazonus",
          "giftbit_email_template": "Test template2",
          "email_subject": null,
          "email_body": null
        }
      ]
    }
  }'
  def update; end

  api :DELETE, '/giftbit_configs/:id', I18n.t('api.resource_description.descriptions.giftbit_configs.delete')
  header 'Authorization', 'Bearer access_token', required: true
  example I18n.t('api.resource_description.fail',
                 description: I18n.t('api.errors.could_not_remove',
                                     model: I18n.t('activerecord.models.beach_api_core/giftbit_config.downcase')))
  def destroy; end

  api :DELETE, '/giftbit_configs/:id/remove_brand/:brand_id', I18n.t('api.resource_description.descriptions.giftbit_configs.remove')
  header 'Authorization', 'Bearer access_token', required: true
  example I18n.t('api.resource_description.fail',
                 description: I18n.t('api.errors.could_not_remove',
                                     model: I18n.t('activerecord.models.beach_api_core/giftbit_config.giftbit_brand')))
  def remove_brand_from_config; end

end
