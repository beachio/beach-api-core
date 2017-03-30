module FavouritesDoc
  extend Apipie::DSL::Concern
  extend BeachApiCore::Concerns::V1::ApipieResponseConcern

  api :GET, '/favourites', 'List of user favourites items'
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example "\"favourites\": [#{apipie_favourite_response}, ...]"
  def index
  end

  api :POST, '/favourites', 'Create favourite item'
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  param :favourite, Hash, required: true do
    param :favouritable_id, String, required: true
    param :favouritable_type, String, required: true
  end
  example "\"favourite\": #{apipie_favourite_response} \nfail: 'Errors Description'"
  def create
  end

  api :DELETE, '/favourites/:id', 'Remove favourite item'
  header 'HTTP_AUTHORIZATION', 'Bearer access_token', required: true
  example "success: 'Favourite item was successfully deleted' \nfail: 'This favourite item could not be deleted'"
  def destroy
  end
end
