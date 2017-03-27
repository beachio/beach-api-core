module BeachApiCore
  class V1::InvitationsController < BeachApiCore::V1::BaseController
    include BeachApiCore::Concerns::V1::GroupResourceConcern
    include InvitationsDoc
    before_action :doorkeeper_authorize!
    before_action :find_group, only: [:create]

    resource_description do
      error code: 403, desc: 'Forbidden request'
      error code: 401, desc: 'Unauthorized'
      error code: 400, desc: 'Bad request'
    end

    def index
      authorize current_organisation, :manage_invitations?
      render_json_success(current_organisation.invitations, :ok,
                          each_serializer: BeachApiCore::InvitationSerializer,
                          root: :invitations)
    end

    def create
      result = BeachApiCore::InvitationCreate.call(params: invitation_params, group: @group, user: current_user)
      if result.success?
        render_json_success(result.invitation, result.status, root: :invitation)
      else
        render_json_error({ message: result.message }, result.status)
      end
    end

    def destroy
      authorize current_organisation, :manage_invitations?
      invitation = current_organisation.invitations.find(params[:id])
      if invitation.destroy
        render_json_success({ message: 'Invitation was revoked successfully' }, :ok)
      else
        render_json_error({ message: 'Could not revoke an invitation' }, :bad_request)
      end
    end

    private

    def invitation_params
      params.require(:invitation).permit(:email, :first_name, :last_name)
    end
  end
end
