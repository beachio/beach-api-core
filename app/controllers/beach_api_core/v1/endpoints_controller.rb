module BeachApiCore
  class V1::EndpointsController < BeachApiCore::V1::BaseController
    include EndpointsDoc
    include BeachApiCore::Concerns::ScreensConcern

    before_action :doorkeeper_authorize!

    resource_description do
      name I18n.t('activerecord.models.beach_api_core/endpoints.other')
    end

    def create
      handler = MixfitCore::Handler.find(params[:handler])
      json = handler.process(current_user.id, data: params.permit!.to_h[:data])
      render json: json
    end

  end
end
