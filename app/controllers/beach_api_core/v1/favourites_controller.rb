module BeachApiCore
  class V1::FavouritesController < BeachApiCore::V1::BaseController
    include BeachApiCore::Concerns::V1::ResourceConcern
    before_action :doorkeeper_authorize!

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
        render_json_success({ message: 'Favourite item was successfully deleted' }, :ok)
      else
        render_json_error({ message: "This favourite item can't be deleted" }, :bad_request)
      end
    end

    private

    def favourite_params
      params.require(:favourite).permit(:favouritable_id, :favouritable_type)
    end
  end
end
