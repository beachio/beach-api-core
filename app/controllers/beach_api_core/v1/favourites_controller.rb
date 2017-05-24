module BeachApiCore
  class V1::FavouritesController < BeachApiCore::V1::BaseController
    include FavouritesDoc
    include BeachApiCore::Concerns::V1::ResourceConcern
    before_action :doorkeeper_authorize!

    resource_description do
      name I18n.t('activerecord.models.beach_api_core/favourite.other')
      error code: 403, desc: I18n.t('api.resource_description.errors.forbidden_request')
      error code: 401, desc: I18n.t('api.resource_description.errors.unauthorized')
      error code: 400, desc: I18n.t('api.resource_description.errors.bad_request')
    end

    def index
      scope = current_user.favourites
      scope = scope.with_favouritable_type(params[:favouritable_type]) if params[:favouritable_type].present?
      render_json_success(scope, :ok, root: :favourites)
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
        render_json_error({ message: I18n.t('api.errors.favourite_item_could_not_be_deleted') }, :bad_request)
      end
    end

    private

    def favourite_params
      params.require(:favourite).permit(:favouritable_id, :favouritable_type)
    end
  end
end
