module BeachApiCore
  class V1::InvitationsController < BeachApiCore::V1::BaseController
    include BeachApiCore::Concerns::V1::GroupResourceConcern
    before_action :doorkeeper_authorize!, :find_group

    api :POST, '/invitations', 'Create an invitation'
    param :invitation, Hash, required: true do
      param :email, String, required: true
      param :group_type, String, required: true
      param :group_id, String, required: true
    end
    example "\"invitation\": #{apipie_invitation_response}"
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
