module BeachApiCore
  class V1::UploadsController < BeachApiCore::V1::BaseController
    include UploadsDoc

    before_action :doorkeeper_authorize!
    before_action :authenticate_service_for_application

    resource_description do
      name I18n.t('activerecord.models.beach_api_core/uploads.other')
    end

    def create
      entity = BeachApiCore::Entity.create(user: current_user, uid: SecureRandom.uuid, kind: "UploadedImage")
      asset = BeachApiCore::Asset.new(entity: entity)
      if params[:attachment_base64]
        asset.base64 = params.permit![:attachment_base64]
      else
        asset.file = params.permit![:attachment]
      end
      asset.save

      render json: {url: asset.file_url, id: asset.id}
    end

  end
end
