module FavouritesDoc
  extend Apipie::DSL::Concern
  extend BeachApiCore::Concerns::V1::ApipieResponseConcern

  api :GET, '/favourites', I18n.t('api.resource_description.descriptions.favourites.list')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param :favouritable_type, String
  example "\"favourites\": [#{apipie_favourite_response}, ...]"
  def index; end

  api :POST, '/favourites', I18n.t('api.resource_description.descriptions.favourites.create')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param :favourite, Hash, required: true do
    param :favouritable_id, String, required: true
    param :favouritable_type, String, required: true
  end
  example "\"favourite\": #{apipie_favourite_response}
          \n#{I18n.t('api.resource_description.fail',
                     description: I18n.t('api.resource_description.fails.errors_description'))}"
  def create; end

  api :DELETE, '/favourites/:id', I18n.t('api.resource_description.descriptions.favourites.remove')
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example I18n.t('api.resource_description.fail', description: I18n.t('api.errors.favourite_item_could_not_be_deleted'))
  def destroy; end
end
