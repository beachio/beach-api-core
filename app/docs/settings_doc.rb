module SettingsDoc
  extend Apipie::DSL::Concern
  extend BeachApiCore::Concerns::V1::ApipieResponseConcern

  api :PUT, '/settings/:name', I18n.t('api.resource_description.descriptions.settings.create_update')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param :group_type, %w(Organisation), required: true
  param :group_id, String, required: true
  param :setting, Hash, required: true do
    param :value, String, required: true
  end
  example "\"setting\": #{apipie_setting_response}"
  def update; end
end
