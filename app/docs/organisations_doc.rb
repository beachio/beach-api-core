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

  def_param_group :address do
    param :address, Hash do
      param :line1, String, required: true
      param :city, String
      param :country, String
      param :line2, String
      param :postal_code, String
      param :state, String
    end
  end

  def_param_group :invoice_settings do
    param :invoice_settings, Hash do
      param :custom_fields, String
      param :default_payment_method, String
      param :footer, String
    end
  end

  def_param_group :shipping do
    param :shipping, Hash do
      param :address, String
      param :name, String
      param :phone, String
    end
  end

  def_param_group :card do
    param :card, Hash do
      param :exp_month, Integer
      param :exp_year, Integer
    end
  end

  def_param_group :card_params do
    param :card_params, Hash do
      param :number, Integer, required: true
      param :exp_month, Integer, required: true
      param :exp_year, Integer, required: true
      param :cvc, Integer
      param :address_city, String
      param :address_country, String
      param :address_line1, String
      param :address_line2, String
      param :address_state, String
      param :address_zip, String
    end
  end

  def_param_group :billing_details do
    param :billing_details, Hash do
      param :email, String
      param :name, String
      param :phone, String
      param_group :address
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

  api :GET, '/organisations/:organisation_id/subscriptions/:id/show_invoices', 'Show invoices subscriptions of organisation'
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

  api :POST, '/organisations/:organisation_id/create_customer', 'Create customer'
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param :card_params, Hash, required: true do
    param :number, Integer, required: true
    param :exp_month, Integer, required: true
    param :exp_year, Integer, required: true
    param :cvc, Integer
  end

  param :address, Hash do
    param :line1, String, required: true
    param :city, String
    param :country, String
    param :line2, String
    param :postal_code, String
    param :state, String
  end

  param :shipping, Hash do
    param :address, String, required: true
    param :name, String, required: true
    param :phone, String
  end

  param :invoice_settings, Hash do
    param :custom_fields, String
    param :default_payment_method, String
    param :footer, String
  end

  param :description, String
  param :metadata, Hash
  param :name, String
  param :phone, String
  param :balance, String

  example '"message": "Customer created successfully"'
  def create_customer; end

  api :GET, '/organisations/:organisation_id/get_customer', 'Get customer'
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example '
  "customer": {
        "id": "cus_Gi39PE79TuCUFz",
        "object": "customer",
        "address": null,
        "balance": 0,
        "created": 1581344167,
        "currency": null,
        "default_source": "card_1GAd3SDwvBLHhcQKHTSsPQC7",
        "delinquent": false,
        "description": null,
        "discount": null,
        "email": "kerrie@howewalsh.net",
        "invoice_prefix": "1B6BC84E",
        "invoice_settings": {
            "custom_fields": null,
            "default_payment_method": null,
            "footer": null
        },
        "livemode": false,
        "metadata": {},
        "name": null,
        "phone": null,
        "preferred_locales": [],
        "shipping": null,
        "sources": {
            "object": "list",
            "data": [
                {
                    "id": "card_1GAd3SDwvBLHhcQKHTSsPQC7",
                    "object": "card",
                    "address_city": null,
                    "address_country": null,
                    "address_line1": null,
                    "address_line1_check": null,
                    "address_line2": null,
                    "address_state": null,
                    "address_zip": null,
                    "address_zip_check": null,
                    "brand": "Visa",
                    "country": "US",
                    "customer": "cus_Gi39PE79TuCUFz",
                    "cvc_check": "pass",
                    "dynamic_last4": null,
                    "exp_month": 12,
                    "exp_year": 2026,
                    "fingerprint": "Vj7DUd8ux6H8XITM",
                    "funding": "credit",
                    "last4": "4242",
                    "metadata": {},
                    "name": null,
                    "tokenization_method": null
                }
            ],
            "has_more": false,
            "total_count": 1,
            "url": "/v1/customers/cus_Gi39PE79TuCUFz/sources"
        },
        "tax_exempt": "none",
        "tax_ids": {
            "object": "list",
            "data": [],
            "has_more": false,
            "total_count": 0,
            "url": "/v1/customers/cus_Gi39PE79TuCUFz/tax_ids"
        },
        "tax_info": null,
        "tax_info_verification": null
    }'
  def get_customer; end

  api :PUT, '/organisations/:organisation_id/update_customer', 'Update customer'
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true

  param :customer_params, Hash do

  param :address, Hash do
    param :line1, String, required: true
    param :city, String
    param :country, String
    param :line2, String
    param :postal_code, String
    param :state, String
  end

  param :shipping, Hash do
    param :address, String, required: true
    param :name, String, required: true
    param :phone, String
  end

  param :invoice_settings, Hash do
    param :custom_fields, String
    param :default_payment_method, String
    param :footer, String
  end

  param :description, String
  param :metadata, Hash
  param :name, String
  param :phone, String
  param :balance, String
  param :email, String

  end
  example '
  "id": "cus_Gi39PE79TuCUFz",
    "object": "customer",
    "address": {
        "city": null,
        "country": null,
        "line1": "Hello12",
        "line2": null,
        "postal_code": null,
        "state": null
    },
    "balance": 0,
    "created": 1581344167,
    "currency": null,
    "default_source": "card_1GAd3SDwvBLHhcQKHTSsPQC7",
    "delinquent": false,
    "description": null,
    "discount": null,
    "email": "kerrie@howewalsh.net",
    "invoice_prefix": "1B6BC84E",
    "invoice_settings": {
        "custom_fields": null,
        "default_payment_method": null,
        "footer": null
    },
    "livemode": false,
    "metadata": {},
    "name": null,
    "phone": null,
    "preferred_locales": [],
    "shipping": null,
    "sources": {
        "object": "list",
        "data": [
            {
                "id": "card_1GAd3SDwvBLHhcQKHTSsPQC7",
                "object": "card",
                "address_city": null,
                "address_country": null,
                "address_line1": null,
                "address_line1_check": null,
                "address_line2": null,
                "address_state": null,
                "address_zip": null,
                "address_zip_check": null,
                "brand": "Visa",
                "country": "US",
                "customer": "cus_Gi39PE79TuCUFz",
                "cvc_check": "pass",
                "dynamic_last4": null,
                "exp_month": 12,
                "exp_year": 2026,
                "fingerprint": "Vj7DUd8ux6H8XITM",
                "funding": "credit",
                "last4": "4242",
                "metadata": {},
                "name": null,
                "tokenization_method": null
            }
        ],
        "has_more": false,
        "total_count": 1,
        "url": "/v1/customers/cus_Gi39PE79TuCUFz/sources"
    },
    "subscriptions": {
        "object": "list",
        "data": [],
        "has_more": false,
        "total_count": 0,
        "url": "/v1/customers/cus_Gi39PE79TuCUFz/subscriptions"
    },
    "tax_exempt": "none",
    "tax_ids": {
        "object": "list",
        "data": [],
        "has_more": false,
        "total_count": 0,
        "url": "/v1/customers/cus_Gi39PE79TuCUFz/tax_ids"
    },
    "tax_info": null,
    "tax_info_verification": null'
  def update_customer; end

  api :DELETE, '/organisations/:organisation_id/delete_customer', 'Delete customer'
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example '
    "id": "cus_Gi39PE79TuCUFz",
    "object": "customer",
    "deleted": true'
  def delete_customer; end

  api :GET, '/organisations/:organisation_id/all_cards', "List of all customer's cards"
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example '{
    "object": "list",
    "data": [
        {
            "id": "card_1GAuwzDwvBLHhcQKdFbIeLwP",
            "object": "card",
            "address_city": null,
            "address_country": null,
            "address_line1": null,
            "address_line1_check": null,
            "address_line2": null,
            "address_state": null,
            "address_zip": null,
            "address_zip_check": null,
            "brand": "Visa",
            "country": "US",
            "customer": "cus_GiLe0Od1YjCAZX",
            "cvc_check": "pass",
            "dynamic_last4": null,
            "exp_month": 12,
            "exp_year": 2025,
            "fingerprint": "Vj7DUd8ux6H8XITM",
            "funding": "credit",
            "last4": "4242",
            "metadata": {},
            "name": null,
            "tokenization_method": null
        },
        {
            "id": "card_1GAuxjDwvBLHhcQKoxwKMjc9",
            "object": "card",
            "address_city": null,
            "address_country": null,
            "address_line1": null,
            "address_line1_check": null,
            "address_line2": null,
            "address_state": null,
            "address_zip": null,
            "address_zip_check": null,
            "brand": "Visa",
            "country": "US",
            "customer": "cus_GiLe0Od1YjCAZX",
            "cvc_check": "pass",
            "dynamic_last4": null,
            "exp_month": 12,
            "exp_year": 2025,
            "fingerprint": "Vj7DUd8ux6H8XITM",
            "funding": "credit",
            "last4": "4242",
            "metadata": {},
            "name": null,
            "tokenization_method": null
        }
    ],
    "has_more": false,
    "url": "/v1/customers/cus_GiLe0Od1YjCAZX/sources"
}'
  def all_cards; end

  api :POST, '/organisations/:organisation_id/add_card', 'Create and add card to customer'
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param_group :card_params

  example '{
    "id": "card_1GAvZWDwvBLHhcQK0s7eHF6S",
    "object": "card",
    "address_city": null,
    "address_country": null,
    "address_line1": null,
    "address_line1_check": null,
    "address_line2": null,
    "address_state": null,
    "address_zip": null,
    "address_zip_check": null,
    "brand": "Visa",
    "country": "US",
    "customer": "cus_GiLe0Od1YjCAZX",
    "cvc_check": "pass",
    "dynamic_last4": null,
    "exp_month": 12,
    "exp_year": 2025,
    "fingerprint": "Vj7DUd8ux6H8XITM",
    "funding": "credit",
    "last4": "4242",
    "metadata": {},
    "name": null,
    "tokenization_method": null
}'
  def add_card; end

  api :PUT, '/organisations/:organisation_id/update_card/:card_id', "Update customer's card"
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param :card_params, Hash, required: true do
    param :exp_month, Integer
    param :exp_year, Integer
  end

  example '{
    "id": "card_1GAvZWDwvBLHhcQK0s7eHF6S",
    "object": "card",
    "address_city": null,
    "address_country": null,
    "address_line1": null,
    "address_line1_check": null,
    "address_line2": null,
    "address_state": null,
    "address_zip": null,
    "address_zip_check": null,
    "brand": "Visa",
    "country": "US",
    "customer": "cus_GiLe0Od1YjCAZX",
    "cvc_check": "pass",
    "dynamic_last4": null,
    "exp_month": 8,
    "exp_year": 2062,
    "fingerprint": "Vj7DUd8ux6H8XITM",
    "funding": "credit",
    "last4": "4242",
    "metadata": {},
    "name": null,
    "tokenization_method": null
}'
  def update_card; end

  api :DELETE, '/organisations/:organisation_id/delete_card/:card_id', "Delete customer's card"
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param :card_id, String, required: true
  example '{
    "id": "card_1GAvZWDwvBLHhcQK0s7eHF6S",
    "object": "card",
    "deleted": true
}'
  def delete_card; end

  api :GET, '/organisations/:organisation_id/all_payment_methods', "List of all customer's payment methods"
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example '{
    "object": "list",
    "data": [
        {
            "id": "pm_1GAv0kDwvBLHhcQKTHOPbiHA",
            "object": "payment_method",
            "billing_details": {
                "address": {
                    "city": null,
                    "country": null,
                    "line1": null,
                    "line2": null,
                    "postal_code": null,
                    "state": null
                },
                "email": null,
                "name": null,
                "phone": null
            },
            "card": {
                "brand": "visa",
                "checks": {
                    "address_line1_check": null,
                    "address_postal_code_check": null,
                    "cvc_check": "pass"
                },
                "country": "US",
                "exp_month": 12,
                "exp_year": 2025,
                "fingerprint": "Vj7DUd8ux6H8XITM",
                "funding": "credit",
                "generated_from": null,
                "last4": "4242",
                "three_d_secure_usage": {
                    "supported": true
                },
                "wallet": null
            },
            "created": 1581413191,
            "customer": "cus_GiLe0Od1YjCAZX",
            "livemode": false,
            "metadata": {},
            "type": "card"
        },
        {
            "id": "card_1GAuxjDwvBLHhcQKoxwKMjc9",
            "object": "payment_method",
            "billing_details": {
                "address": {
                    "city": null,
                    "country": null,
                    "line1": null,
                    "line2": null,
                    "postal_code": null,
                    "state": null
                },
                "email": null,
                "name": null,
                "phone": null
            },
            "card": {
                "brand": "visa",
                "checks": {
                    "address_line1_check": null,
                    "address_postal_code_check": null,
                    "cvc_check": "pass"
                },
                "country": "US",
                "exp_month": 12,
                "exp_year": 2025,
                "fingerprint": "Vj7DUd8ux6H8XITM",
                "funding": "credit",
                "generated_from": null,
                "last4": "4242",
                "three_d_secure_usage": {
                    "supported": true
                },
                "wallet": null
            },
            "created": 1581413003,
            "customer": "cus_GiLe0Od1YjCAZX",
            "livemode": false,
            "metadata": {},
            "type": "card"
        },
        {
            "id": "card_1GAuwzDwvBLHhcQKdFbIeLwP",
            "object": "payment_method",
            "billing_details": {
                "address": {
                    "city": null,
                    "country": null,
                    "line1": null,
                    "line2": null,
                    "postal_code": null,
                    "state": null
                },
                "email": null,
                "name": null,
                "phone": null
            },
            "card": {
                "brand": "visa",
                "checks": {
                    "address_line1_check": null,
                    "address_postal_code_check": null,
                    "cvc_check": "pass"
                },
                "country": "US",
                "exp_month": 12,
                "exp_year": 2025,
                "fingerprint": "Vj7DUd8ux6H8XITM",
                "funding": "credit",
                "generated_from": null,
                "last4": "4242",
                "three_d_secure_usage": {
                    "supported": true
                },
                "wallet": null
            },
            "created": 1581412957,
            "customer": "cus_GiLe0Od1YjCAZX",
            "livemode": false,
            "metadata": {},
            "type": "card"
        }
    ],
    "has_more": false,
    "url": "/v1/payment_methods"
}'
  def all_payment_methods; end

  api :POST, '/organisations/:organisation_id/add_payment_method', 'Create and add payment method to customer'
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param_group :card_params
  example '{
    "id": "pm_1GAvfwDwvBLHhcQK5Banr4RY",
    "object": "payment_method",
    "billing_details": {
        "address": {
            "city": null,
            "country": null,
            "line1": null,
            "line2": null,
            "postal_code": null,
            "state": null
        },
        "email": null,
        "name": null,
        "phone": null
    },
    "card": {
        "brand": "visa",
        "checks": {
            "address_line1_check": null,
            "address_postal_code_check": null,
            "cvc_check": "pass"
        },
        "country": "US",
        "exp_month": 12,
        "exp_year": 2025,
        "fingerprint": "Vj7DUd8ux6H8XITM",
        "funding": "credit",
        "generated_from": null,
        "last4": "4242",
        "three_d_secure_usage": {
            "supported": true
        },
        "wallet": null
    },
    "created": 1581415745,
    "customer": "cus_GiLe0Od1YjCAZX",
    "livemode": false,
    "metadata": {},
    "type": "card"
}'
  def add_payment_method; end

  api :PUT, '/organisations/:organisation_id/update_payment_method', "Update customer's payment method"
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param :payment_method_id, String, required: true
  param_group :card
  param_group :billing_details
  param :metadata, Hash
  example '{
    "id": "pm_1GAv0kDwvBLHhcQKTHOPbiHA",
    "object": "payment_method",
    "billing_details": {
        "address": {
            "city": null,
            "country": null,
            "line1": null,
            "line2": null,
            "postal_code": null,
            "state": null
        },
        "email": null,
        "name": null,
        "phone": null
    },
    "card": {
        "brand": "visa",
        "checks": {
            "address_line1_check": null,
            "address_postal_code_check": null,
            "cvc_check": "pass"
        },
        "country": "US",
        "exp_month": 12,
        "exp_year": 2055,
        "fingerprint": "Vj7DUd8ux6H8XITM",
        "funding": "credit",
        "generated_from": null,
        "last4": "4242",
        "three_d_secure_usage": {
            "supported": true
        },
        "wallet": null
    },
    "created": 1581413191,
    "customer": "cus_GiLe0Od1YjCAZX",
    "livemode": false,
    "metadata": {},
    "type": "card"
}'
  def update_payment_method; end

  api :DELETE, '/organisations/:organisation_id/detach_payment_method', "Delete and detach customer's payment method"
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param :payment_method_id, String, required: true
  example '{
    "id": "pm_1GAvfwDwvBLHhcQK5Banr4RY",
    "object": "payment_method",
    "billing_details": {
        "address": {
            "city": null,
            "country": null,
            "line1": null,
            "line2": null,
            "postal_code": null,
            "state": null
        },
        "email": null,
        "name": null,
        "phone": null
    },
    "card": {
        "brand": "visa",
        "checks": {
            "address_line1_check": null,
            "address_postal_code_check": null,
            "cvc_check": "pass"
        },
        "country": "US",
        "exp_month": 12,
        "exp_year": 2025,
        "fingerprint": "Vj7DUd8ux6H8XITM",
        "funding": "credit",
        "generated_from": null,
        "last4": "4242",
        "three_d_secure_usage": {
            "supported": true
        },
        "wallet": null
    },
    "created": 1581415745,
    "customer": null,
    "livemode": false,
    "metadata": {},
    "type": "card"
}'
  def detach_payment_method; end

  api :POST, '/organisations/:organisation_id/set_default_payment_method', 'Set default payment method to the customer'
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param :payment_method_id, String, required: true
  example '{
    "id": "cus_GiLe0Od1YjCAZX",
    "object": "customer",
    "address": null,
    "balance": 0,
    "created": 1581412957,
    "currency": null,
    "default_source": "card_1GAuwzDwvBLHhcQKdFbIeLwP",
    "delinquent": false,
    "description": null,
    "discount": null,
    "email": "new_organisation_test@gmail.com",
    "invoice_prefix": "44ED3D90",
    "invoice_settings": {
        "custom_fields": null,
        "default_payment_method": "pm_1GAv0kDwvBLHhcQKTHOPbiHA",
        "footer": null
    },
    "livemode": false,
    "metadata": {},
    "name": null,
    "phone": null,
    "preferred_locales": [],
    "shipping": null,
    "sources": {
        "object": "list",
        "data": [
            {
                "id": "card_1GAuwzDwvBLHhcQKdFbIeLwP",
                "object": "card",
                "address_city": null,
                "address_country": null,
                "address_line1": null,
                "address_line1_check": null,
                "address_line2": null,
                "address_state": null,
                "address_zip": null,
                "address_zip_check": null,
                "brand": "Visa",
                "country": "US",
                "customer": "cus_GiLe0Od1YjCAZX",
                "cvc_check": "pass",
                "dynamic_last4": null,
                "exp_month": 12,
                "exp_year": 2025,
                "fingerprint": "Vj7DUd8ux6H8XITM",
                "funding": "credit",
                "last4": "4242",
                "metadata": {},
                "name": null,
                "tokenization_method": null
            },
            {
                "id": "card_1GAuxjDwvBLHhcQKoxwKMjc9",
                "object": "card",
                "address_city": null,
                "address_country": null,
                "address_line1": null,
                "address_line1_check": null,
                "address_line2": null,
                "address_state": null,
                "address_zip": null,
                "address_zip_check": null,
                "brand": "Visa",
                "country": "US",
                "customer": "cus_GiLe0Od1YjCAZX",
                "cvc_check": "pass",
                "dynamic_last4": null,
                "exp_month": 12,
                "exp_year": 2025,
                "fingerprint": "Vj7DUd8ux6H8XITM",
                "funding": "credit",
                "last4": "4242",
                "metadata": {},
                "name": null,
                "tokenization_method": null
            }
        ],
        "has_more": false,
        "total_count": 2,
        "url": "/v1/customers/cus_GiLe0Od1YjCAZX/sources"
    },
    "subscriptions": {
        "object": "list",
        "data": [],
        "has_more": false,
        "total_count": 0,
        "url": "/v1/customers/cus_GiLe0Od1YjCAZX/subscriptions"
    },
    "tax_exempt": "none",
    "tax_ids": {
        "object": "list",
        "data": [],
        "has_more": false,
        "total_count": 0,
        "url": "/v1/customers/cus_GiLe0Od1YjCAZX/tax_ids"
    },
    "tax_info": null,
    "tax_info_verification": null
}'
  def set_default_payment_method; end

  api :GET, '/organisations/:organisation_id/subscription', 'Get subscription'
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example '{
    "id": 1,
    "subscription_for": "organisation",
    "plan": {
        "id": 2,
        "stripe_id": "test_plan",
        "name": "test_Plan",
        "amount": 4500,
        "interval": "year",
        "plan_for": "organisation"
    }
  }'
  def subscription; end
end
