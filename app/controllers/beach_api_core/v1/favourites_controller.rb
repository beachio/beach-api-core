module BeachApiCore
  class V1::FavouritesController < BeachApiCore::V1::BaseController
    include BeachApiCore::Concerns::V1::ResourceConcern
    before_action :doorkeeper_authorize!

    resource_description do
      error code: 403, desc: 'Forbidden request'
      error code: 401, desc: 'Unauthorized'
      error code: 400, desc: 'Bad request'
    end

    api :GET, '/favourites', 'List of user favourites items'
    example "\"favourites\": [#{apipie_favourite_response}, ...]"
    def index
      render_json_success(current_user.favourites, :ok, root: :favourites)
    end

    api :POST, '/favourites', 'Create favourite item'
    param :favourite, Hash, required: true do
      param :favouritable_id, String, required: true
      param :favouritable_type, String, required: true
    end
    example "\"favourite\": #{apipie_favourite_response} \nfail: 'Errors Description'"
    def create
      result = BeachApiCore::FavouriteCreate.call(user: current_user, params: favourite_params)

      if result.success?
        render_json_success(result.favourite, result.status, root: :favourite)
      else
        render_json_error({ message: result.message }, result.status)
      end
    end

    api :DELETE, '/favourites', 'Remove favourite item'
    example "success: 'Favourite item was successfully deleted' \nfail: 'This favourite item could not be deleted'"
    def destroy
      authorize @favourite
      if @favourite.destroy
        render_json_success({ message: 'Favourite item was successfully deleted' }, :ok)
      else
        render_json_error({ message: 'This favourite item could not be deleted' }, :bad_request)
      end
    end

    private

    def favourite_params
      params.require(:favourite).permit(:favouritable_id, :favouritable_type)
    end
  end
end
