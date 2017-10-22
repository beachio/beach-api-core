module BeachApiCore
  class V1::UserAccessesController < BeachApiCore::V1::BaseController
    include UserAccessesDoc
    before_action :doorkeeper_authorize!
    before_action :check_user_membership!, only: :create

    resource_description do
      name I18n.t('activerecord.models.beach_api_core/user_access.other')
      error code: 403, desc: I18n.t('api.resource_description.errors.forbidden_request')
      error code: 401, desc: I18n.t('api.resource_description.errors.unauthorized')
      error code: 404, desc: I18n.t('api.resource_description.errors.user_does_not_belong_to_organisation')
    end

    def create
      authorize current_organisation, :update?
      result = BeachApiCore::UserAccessCreate.call(params: user_access_params, organisation: current_organisation)
      if result.success?
        render_json_success(result.user_access, result.status, root: :user_access)
      else
        render_json_error({ message: result.message }, result.status)
      end
    end

    def destroy
      authorize current_organisation, :update?
      @user_access = current_organisation.user_accesses.find(params[:id])
      if @user_access.destroy
        head :no_content
      else
        render_json_error({ message: I18n.t('api.errors.could_not_remove',
                                            model: I18n.t('activerecord.models.beach_api_core/access_level.downcase')) },
                          :bad_request)
      end
    end

    private

    def user_access_params
      params.require(:user_access).permit(:user_id, :access_level_id)
    end

    def check_user_membership!
      raise ActiveRecord::RecordNotFound unless current_organisation.users.exists?(user_access_params[:user_id])
    end
  end
end
