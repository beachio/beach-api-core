module BeachApiCore
  class V1::InteractionsController < BeachApiCore::V1::BaseController
    include InteractionsDoc
    before_action :doorkeeper_authorize!
    before_action :authenticate_service_for_application

    resource_description do
      name I18n.t('activerecord.models.beach_api_core/interaction.other')
      error code: 403, desc: I18n.t('api.resource_description.errors.forbidden_request')
      error code: 401, desc: I18n.t('api.resource_description.errors.unauthorized')
      error code: 400, desc: I18n.t('api.resource_description.errors.bad_request')
    end

    def create
      result = BeachApiCore::InteractionCreate.call(user: current_user, params: interaction_params)

      if result.success?
        render_json_success(result.interaction, result.status,
                            root: :interaction,
                            serializer: BeachApiCore::SimpleInteractionSerializer)
      else
        render_json_error({ message: result.message }, result.status)
      end
    end

    private

    def interaction_params
      params.require(:interaction).permit(:kind,
                                          interaction_attributes_attributes: [:key, values: {}],
                                          interaction_keepers_attributes: %i(keeper_type keeper_id))
    end
  end
end
