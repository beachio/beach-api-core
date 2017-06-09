module BeachApiCore
  class V1::EntitiesController < BeachApiCore::V1::BaseController
    include EntitiesDoc
    include BeachApiCore::Concerns::V1::ResourceConcern
    before_action :doorkeeper_authorize!
    before_action :ensure_entity_params, only: [:lookup]

    resource_description do
      name I18n.t('activerecord.models.beach_api_core/entity.other')
      error code: 403, desc: I18n.t('api.resource_description.errors.forbidden_request')
      error code: 401, desc: I18n.t('api.resource_description.errors.unauthorized')
      error code: 400, desc: I18n.t('api.resource_description.errors.bad_request')
    end

    def show
      authorize @entity
      render_json_success(@entity, :ok, root: :entity)
    end

    def create
      result = BeachApiCore::EntityCreate.call(user: current_user, params: entity_params)

      if result.success?
        render_json_success(result.entity, result.status, root: :entity)
      else
        render_json_error({ message: result.message }, result.status)
      end
    end

    def destroy
      authorize @entity
      if @entity.destroy
        head :no_content
      else
        render_json_error({ message: I18n.t('api.errors.could_not_remove',
                                            model: I18n.t('activerecord.models.entity.downcase')) }, :bad_request)
      end
    end

    def lookup
      @entity = Entity.find_by(entity_lookup_params)
      authorize @entity
      render_json_success(@entity, :ok, root: :entity)
    end

    private

    def entity_params
      params.require(:entity).permit(:uid, :kind, settings: {})
    end

    def entity_lookup_params
      params.require(:entity).permit(:uid, :kind)
    end

    def ensure_entity_params
      return if params[:entity][:uid].present? && params[:entity][:kind].present?
      render_json_error({ message: I18n.t('api.errors.some_parameters_are_absent') }, :bad_request)
    end
  end
end
