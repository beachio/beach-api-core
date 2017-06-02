module InteractionsDoc
  extend Apipie::DSL::Concern
  extend BeachApiCore::Concerns::V1::ApipieResponseConcern

  api :POST, '/interactions', I18n.t('api.resource_description.descriptions.interactions.create')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param :kind, String, required: true
  param :interaction_attributes_attributes, Array do
    param :key, String, required: true
    param :values, Hash
  end
  param :interaction_keepers_attributes, Array, required: true do
    param :keeper_type, String, required: true
    param :keeper_id, Integer, required: true
  end
  example "\"interaction\": #{apipie_interaction_response}
          \n#{I18n.t('api.resource_description.fail',
                     description: I18n.t('api.resource_description.fails.errors_description'))}"
  def create; end
end
