module BeachApiCore
  class V1::ScreensController < BeachApiCore::V1::BaseController
    include ScreensDoc
    include BeachApiCore::Concerns::ScreensConcern

    before_action :doorkeeper_authorize!

    resource_description do
      name I18n.t('activerecord.models.beach_api_core/screens.other')
    end

  end
end
