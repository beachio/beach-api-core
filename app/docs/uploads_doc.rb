module UploadsDoc
  extend Apipie::DSL::Concern
  extend BeachApiCore::Concerns::V1::ApipieResponseConcern

  api :POST, '/uploads', I18n.t('api.resource_description.descriptions.uploads.upload')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  def create; end
end
