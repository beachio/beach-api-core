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
      data = params.permit!.to_h[:data].with_indifferent_access
      data[:task_id] = params[:task_id] if params[:task_id]
      result = handler.process(current_user.id, data)
      render json: result.to_json, status: (result[:errors] rescue nil) ? 406 : 200
    end

  end
end
