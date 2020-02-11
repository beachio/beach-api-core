module UsersDoc
  extend Apipie::DSL::Concern
  extend BeachApiCore::Concerns::V1::ApipieResponseConcern

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

  api :POST, '/users', I18n.t('api.resource_description.descriptions.users.create')
  param :user, Hash, required: true do
    param :email, String, required: true
    param :username, String
    param :password, String, required: true
  end
  example "\"user\": #{apipie_user_response}, \n\"access_token\": \"#{SecureRandom.hex(16)}\"
          \n#{I18n.t('api.resource_description.fail',
                     description: I18n.t('api.resource_description.fails.errors_description'))}"
  header 'AUTHORIZATION', 'application_id application_uid, client_secret application_secret', required: true
  def create; end

  api :GET, '/user', I18n.t('api.resource_description.descriptions.users.get')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example "\"user\": #{apipie_user_response}"
  def show; end

  api :PUT, '/users/confirm_user/:id', "Confirm user with indicated id"
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example '{
  "message": "User with id: 48 was successfully confirmed"
}'
  def force_confirm_user; end

  api :PUT, '/user', I18n.t('api.resource_description.descriptions.users.update')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param :user, Hash, required: true do
    param :email, String, required: true
    param :username, String
    param :profile_attributes, Hash do
      param :id, Integer, required: true
      param :first_name, String
      param :last_name, String
      param :current_password, String
      param :password, String
      param :password_confirmation, String
      param :sex, %w(male female)
      param :birth_date, Date, desc: I18n.t('api.resource_description.descriptions.params.birth_date')
      param :'***', String, desc: I18n.t('api.resource_description.descriptions.params.any_custom_field')
      param :avatar_attributes, Hash do
        param :file, File, desc: I18n.t('api.resource_description.descriptions.params.postfield_file')
        param :base64, String, desc: I18n.t('api.resource_description.descriptions.params.encoded_string')
      end
      param :current_age, Integer, desc: I18n.t('api.resource_description.descriptions.params.current_age')
    end
    param :user_preferences_attributes, Array do
      param :id, Integer, required: true
      param :preferences, Hash, required: true
    end
  end
  example "\"user\": #{apipie_user_response}
          \n#{I18n.t('api.resource_description.fail',
                     description: I18n.t('api.resource_description.fails.errors_description'))}"
  def update; end

  api :POST, '/users/:id/confirm', I18n.t('api.resource_description.descriptions.users.confirm')
  param :confirmation_token, String, required: true
  example "\"user\": #{apipie_user_response}"
  def confirm; end

  api :GET, '/users/:user_id/subscription/:id/show_invoices', 'Show invoices subscriptions of User'
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example "[
    {
        \"id\": 5,
        \"keeper_type\": \"BeachApiCore::User\",
        \"keeper_id\": 12,
        \"subscription_id\": 10,
        \"invoice_url_link\": \"https://pay.stripe.com/invoice/invst_yHsTACRTbcbf1h1awdWRTasdz31zs\",
        \"invoice_pdf_link\": \"https://pay.stripe.com/invoice/invst_yHsTACRTbcbf1h1awdWRTasdz31zs/pdf\",
        \"created_at\": \"2019-12-16T08:22:18.185Z\",
        \"updated_at\": \"2019-12-16T08:22:18.185Z\"
    },
    {...}
]"
  def show_invoices; end

  api :POST, '/users/:user_id/create_customer', 'Create customer'
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

  api :GET, '/users/:user_id/get_customer', 'Get customer'
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

  api :PUT, '/users/:user_id/update_customer', 'Update customer'
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

  api :DELETE, '/users/:user_id/delete_customer', 'Delete customer'
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example '
    "id": "cus_Gi39PE79TuCUFz",
    "object": "customer",
    "deleted": true'
  def delete_customer; end

  api :GET, '/users/:user_id/all_cards', "List of all customer's cards"
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

  api :POST, '/users/:user_id/add_card', 'Create and add card to customer'
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

  api :PUT, '/users/:user_id/update_card', "Update customer's card"
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

  api :DELETE, '/users/:user_id/delete_card', "Delete customer's card"
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param :card_id, String, required: true
  example '{
    "id": "card_1GAvZWDwvBLHhcQK0s7eHF6S",
    "object": "card",
    "deleted": true
}'
  def delete_card; end

  api :GET, '/users/:user_id/all_payment_methods', "List of all customer's payment methods"
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

  api :POST, '/users/:user_id/add_payment_method', 'Create and add payment method to customer'
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

  api :PUT, '/users/:user_id/update_payment_method', "Update customer's payment method"
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

  api :DELETE, '/users/:user_id/detach_payment_method', "Delete and detach customer's payment method"
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

  api :POST, '/users/:user_id/set_default_payment_method', 'Set default payment method to the customer'
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

  api :GET, '/users/:user_id/subscription', 'Get subscription'
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example '{
    "id": "sub_GdY2u9JXusIPHb",
    "object": "subscription",
    "application_fee_percent": null,
    "billing_cycle_anchor": 1580305841,
    "billing_thresholds": null,
    "cancel_at": null,
    "cancel_at_period_end": false,
    "canceled_at": 1581064397,
    "collection_method": "charge_automatically",
    "created": 1580305841,
    "current_period_end": 1581083441,
    "current_period_start": 1580997041,
    "customer": "cus_GdXw6h0vng0YyK",
    "days_until_due": null,
    "default_payment_method": null,
    "default_source": null,
    "default_tax_rates": [],
    "discount": null,
    "ended_at": 1581064397,
    "invoice_customer_balance_settings": {
        "consume_applied_balance_on_void": true
    },
    "items": {
        "object": "list",
        "data": [
            {
                "id": "si_GdY2nnTgEQfWji",
                "object": "subscription_item",
                "billing_thresholds": null,
                "created": 1580305841,
                "metadata": {},
                "plan": {
                    "id": "SSSSSSSSt",
                    "object": "plan",
                    "active": true,
                    "aggregate_usage": null,
                    "amount": null,
                    "amount_decimal": null,
                    "billing_scheme": "tiered",
                    "created": 1580297327,
                    "currency": "usd",
                    "interval": "day",
                    "interval_count": 1,
                    "livemode": false,
                    "metadata": {},
                    "nickname": null,
                    "product": "prod_GdVkrYdwTKcbwJ",
                    "tiers": [
                        {
                            "flat_amount": 100,
                            "flat_amount_decimal": "100",
                            "unit_amount": null,
                            "unit_amount_decimal": null,
                            "up_to": 10
                        },
                        {
                            "flat_amount": null,
                            "flat_amount_decimal": null,
                            "unit_amount": 100,
                            "unit_amount_decimal": "100",
                            "up_to": null
                        }
                    ],
                    "tiers_mode": "graduated",
                    "transform_usage": null,
                    "trial_period_days": null,
                    "usage_type": "licensed"
                },
                "quantity": 1,
                "subscription": "sub_GdY2u9JXusIPHb",
                "tax_rates": []
            }
        ],
        "has_more": false,
        "total_count": 1,
        "url": "/v1/subscription_items?subscription=sub_GdY2u9JXusIPHb"
    },
    "latest_invoice": "in_1G9AkyDwvBLHhcQKvErrMBRG",
    "livemode": false,
    "metadata": {},
    "next_pending_invoice_item_invoice": null,
    "pending_invoice_item_interval": null,
    "pending_setup_intent": null,
    "pending_update": null,
    "plan": {
        "id": "SSSSSSSSt",
        "object": "plan",
        "active": true,
        "aggregate_usage": null,
        "amount": null,
        "amount_decimal": null,
        "billing_scheme": "tiered",
        "created": 1580297327,
        "currency": "usd",
        "interval": "day",
        "interval_count": 1,
        "livemode": false,
        "metadata": {},
        "nickname": null,
        "product": "prod_GdVkrYdwTKcbwJ",
        "tiers": [
            {
                "flat_amount": 100,
                "flat_amount_decimal": "100",
                "unit_amount": null,
                "unit_amount_decimal": null,
                "up_to": 10
            },
            {
                "flat_amount": null,
                "flat_amount_decimal": null,
                "unit_amount": 100,
                "unit_amount_decimal": "100",
                "up_to": null
            }
        ],
        "tiers_mode": "graduated",
        "transform_usage": null,
        "trial_period_days": null,
        "usage_type": "licensed"
    },
    "quantity": 1,
    "schedule": null,
    "start_date": 1580305841,
    "status": "canceled",
    "tax_percent": null,
    "trial_end": null,
    "trial_start": null
}'
  def subscription; end
end
