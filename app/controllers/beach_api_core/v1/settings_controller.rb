module BeachApiCore
  class V1::SettingsController < V1::BaseController
    include BeachApiCore::Concerns::V1::GroupResourceConcern
    include SettingsDoc
    before_action :doorkeeper_authorize!
    before_action :find_group, only: [:update]

    resource_description do
      name I18n.t('activerecord.models.beach_api_core/setting.other')
    end

    def update
      authorize @group, :update?
      result = SettingUpdate.call(keeper: @group,
                                  name: params[:id],
                                  params: setting_params)
      if result.success?
        render_json_success(result.setting, result.status, root: :setting)
      else
        render_json_error({ message: result.message }, result.status)
      end
    end

    private

    def setting_params
      params.require(:setting).permit(:value)
    end
  end
end
