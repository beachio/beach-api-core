module BeachApiCore
  class V1::UploadsController < BeachApiCore::V1::BaseController
    include UploadsDoc

    before_action :doorkeeper_authorize!

    resource_description do
      name I18n.t('activerecord.models.beach_api_core/uploads.other')
    end

    def create
      entity = BeachApiCore::Entity.create(user: current_user, uid: SecureRandom.uuid, kind: "UploadedImage")
      if params[:attachment_base64]
        image = Paperclip.io_adapters.for(params[:attachment_base64])
        image.original_filename = "image.png"
      else
        image = params.permit![:attachment]
      end
      asset = BeachApiCore::Asset.create(file: image, entity: entity)

      render json: {url: asset.file_url, id: asset.id}
    end

  end
end
