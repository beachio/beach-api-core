module BeachApiCore
  class V1::UploadsController < BeachApiCore::V1::BaseController
    include UploadsDoc

    before_action :doorkeeper_authorize!

    resource_description do
      name I18n.t('activerecord.models.beach_api_core/uploads.other')
    end

    def create
      entity = BeachApiCore::Entity.create(user: current_user, uid: SecureRandom.uuid, kind: "UploadedImage")
      asset = BeachApiCore::Asset.create(file: params.permit![:attachment], entity: entity)

      render json: {url: asset.file_url, id: asset.id}
    end

  end
end
