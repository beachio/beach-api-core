module BeachApiCore
  class V1::MembershipsController < BeachApiCore::V1::BaseController
    include BeachApiCore::Concerns::V1::GroupResourceConcern
    include MembershipsDoc
    before_action :doorkeeper_authorize!
    before_action :find_group, only: [:create]

    resource_description do
      name I18n.t('activerecord.models.beach_api_core/membership.other')
      error code: 403, desc: I18n.t('api.resource_description.errors.forbidden_request')
      error code: 401, desc: I18n.t('api.resource_description.errors.unauthorized')
      error code: 400, desc: I18n.t('api.resource_description.errors.bad_request')
    end

    def create
      result = BeachApiCore::MembershipCreate.call(params: membership_params, group: @group)

      if result.success?
        render_json_success(result.group, result.status, root: @group.class.to_s.underscore)
      else
        render_json_error({ message: result.message }, result.status)
      end
    end

    def destroy
      @membership = Membership.find(params[:id])
      authorize @membership
      if @membership.destroy
        head :no_content
      else
        render_json_error({ message: I18n.t('api.errors.could_not_remove',
                                            model: I18n.t('activerecord.models.beach_api_core/membership.downcase')) },
                          :bad_request)
      end
    end

    private

    def membership_params
      params.require(:membership).permit(:member_id, :member_type, :owner)
    end
  end
end
