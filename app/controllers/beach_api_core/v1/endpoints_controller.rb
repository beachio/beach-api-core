module BeachApiCore
  class V1::EndpointsController < BeachApiCore::V1::BaseController
    include EndpointsDoc
    include BeachApiCore::Concerns::ScreensConcern

    before_action :doorkeeper_authorize!

    resource_description do
      name I18n.t('activerecord.models.beach_api_core/endpoints.other')
    end


    def index
      render json: {}
    end

    def create
      @model = params[:model].constantize
      if params[:entity_id]
        @model = @model.find(params[:entity_id])
      end
      @model.execute_action(params[:action_name], current_user, params[:data])
      render json: {}
    end
  end
end
