module BeachApiCore
  class V1::FavouritesController < BeachApiCore::V1::BaseController
    include FavouritesDoc
    include BeachApiCore::Concerns::V1::ResourceConcern
    before_action :doorkeeper_authorize!

    resource_description do
      name 'Favourites'
      error code: 403, desc: 'Forbidden request'
      error code: 401, desc: 'Unauthorized'
      error code: 400, desc: 'Bad request'
    end

    def index
      render_json_success(current_user.favourites, :ok, root: :favourites)
    end

    def create
      result = BeachApiCore::FavouriteCreate.call(user: current_user, params: favourite_params)

      if result.success?
        render_json_success(result.favourite, result.status, root: :favourite)
      else
        render_json_error({ message: result.message }, result.status)
      end
    end

    def destroy
      authorize @favourite
      if @favourite.destroy
        head :no_content
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
