module BeachApiCore
  class V1::InvitationsController < BeachApiCore::V1::BaseController
    include BeachApiCore::Concerns::V1::GroupResourceConcern
    include InvitationsDoc
    before_action :doorkeeper_authorize!, :find_group

    resource_description do
      error code: 403, desc: 'Forbidden request'
      error code: 401, desc: 'Unauthorized'
      error code: 400, desc: 'Bad request'
    end

    def create
      result = BeachApiCore::InvitationCreate.call(params: invitation_params, group: @group, user: current_user)
      if result.success?
        render_json_success(result.invitation, result.status, root: :invitation)
      else
        render_json_error({ message: result.message }, result.status)
      end
    end

    def invitation_params
      params.require(:invitation).permit(:email)
    end
  end
end
