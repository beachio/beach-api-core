module BeachApiCore
  class V1::EntityMessagesController < BeachApiCore::V1::BaseController
    include EntityMessagesDoc

    before_action :doorkeeper_authorize!
    before_action :load_entity
    before_action :load_interaction, only: %i(update destroy)
    before_action :set_default_serializer

    resource_description do
      name I18n.t('activerecord.models.beach_api_core/entity_message.capital_other')
      error code: 403, desc: I18n.t('api.resource_description.errors.forbidden_request')
      error code: 401, desc: I18n.t('api.resource_description.errors.unauthorized')
      error code: 400, desc: I18n.t('api.resource_description.errors.bad_request')
    end

    def index
      authorize @entity, :show?
      yield if block_given?

      render_json_success(interactions, :ok,
                          root: :interactions,
                          each_serializer: @serializer,
                          doorkeeper_token: doorkeeper_token)
    end

    def create
      authorize @entity, :update?
      if block_given?
        yield
      else
        @result = BeachApiCore::EntityMessageInteractor::Create.call(doorkeeper_token: doorkeeper_token,
                                                                     user: current_user,
                                                                     entity: @entity,
                                                                     message_text: message_text,
                                                                     params: interaction_params)
      end

      if @result.success?
        render_json_success(@result.interaction, @result.status,
                            root: :interaction,
                            serializer: @serializer,
                            doorkeeper_token: doorkeeper_token)
      else
        render_json_error({ message: @result.message }, @result.status)
      end
    end

    def update
      authorize @entity, :update?
      if block_given?
        yield
      else
        @result = BeachApiCore::EntityMessageInteractor::Update.call(doorkeeper_token: doorkeeper_token,
                                                                     interaction: @interaction,
                                                                     message_text: message_text)
      end

      if @result.success?
        render_json_success(@result.interaction, @result.status,
                            root: :interaction,
                            serializer: @serializer,
                            doorkeeper_token: doorkeeper_token)
      else
        render_json_error({ message: @result.message }, @result.status)
      end
    end

    def destroy
      authorize @entity, :update?
      if block_given?
        yield
      else
        @result = BeachApiCore::InteractionDestroy.call(doorkeeper_token: doorkeeper_token,
                                                        interaction: @interaction)
      end

      if @result.success?
        head :no_content
      else
        render_json_error({ message: @result.message }, @result.status)
      end
    end

    protected

    def message_params
      params.require(:message).permit(:text)
    end

    def message_text
      message_params[:text]
    end

    def interaction_params
      {
        kind: 'chat',
        interaction_keepers_attributes: [{ keeper: @entity }],
        interaction_attributes_attributes: [{ key: 'message', values: { text: message_text } }]
      }
    end

    def interactions
      entity_interaction_keepers = BeachApiCore::InteractionKeeper.where(keeper: @entity).select(:id)
      BeachApiCore::Interaction.joins(:interaction_keepers)
        .where(kind: 'chat', beach_api_core_interaction_keepers: { id: entity_interaction_keepers })
        .distinct
    end

    private

    def load_entity
      @entity = BeachApiCore::Entity.find(params[:entity_id])
    end

    def load_interaction
      @interaction = BeachApiCore::Interaction.find(params[:id])
    end

    def set_default_serializer
      @serializer = BeachApiCore::SimpleInteractionSerializer
    end
  end
end
