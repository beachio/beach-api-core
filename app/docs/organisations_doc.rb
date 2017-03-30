module OrganisationsDoc
  extend Apipie::DSL::Concern
  extend BeachApiCore::Concerns::V1::ApipieResponseConcern

  def_param_group :organisation do
    param :organisation, Hash, required: true do
      param :name, String, required: true
      param :logo_properties, Hash
      param :logo_image_attributes, Hash do
        param :file, File, desc: 'Postfield file'
        param :base64, String, desc: 'Encoded Base64 string'
      end
    end
  end

  api :GET, '/organisations', 'List of user organisations'
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example "\"organisations\": [#{apipie_organisation_response}, ...]"
  def index
  end

  api :POST, '/organisations', 'Create an organisation'
  param_group :organisation
  example "\"organisation\": #{apipie_organisation_response} \nfail: 'Errors Description'"
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  def create
  end

  api :GET, '/organisations/:id', 'Get organisation'
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example "\"organisation\": #{apipie_organisation_response}"
  def show
  end

  api :PUT, '/organisations/:id', 'Update organisation'
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param_group :organisation
  example "\"organisation\": #{apipie_organisation_response} \nfail: 'Errors Description'"
  def update
  end

  api :DELETE, '/organisations/:id', 'Remove organisation'
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example "success: 'Organisation was successfully deleted' \nfail: 'Could not remove organisation'"
  def destroy
  end

  api :GET, '/organisations/users', 'Get organisation users for organisation owner'
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param :term, String, desc: 'Term for autocomplete'
  example "\"users\": [#{apipie_organisation_user_response}, ...]"
  def users
  end

  api :PUT, '/organisations/:id/current', 'Set organisation context'
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  def current
  end
end
