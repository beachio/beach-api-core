module BeachApiCore
  class V1::InvitationsController < BeachApiCore::V1::BaseController
    include BeachApiCore::Concerns::V1::GroupResourceConcern
    include BeachApiCore::Concerns::V1::ResourceConcern
    include InvitationsDoc
    before_action :doorkeeper_authorize!, except: [:accept]
    before_action :find_group, except: [:destroy]
    skip_before_action :find_group, only: :accept

    resource_description do
      name 'Invitations'
      error code: 403, desc: 'Forbidden request'
      error code: 401, desc: 'Unauthorized'
      error code: 400, desc: 'Bad request'
    end

    def index
      authorize @group, :update?
      render_json_success(@group.invitations, :ok,
                          each_serializer: BeachApiCore::InvitationSerializer,
                          root: :invitations)
    end

    def create
      result = BeachApiCore::InvitationCreate.call(params: invitation_params,
                                                   group: @group,
                                                   user: current_user)
      if result.success?
        render_json_success(result.invitation, result.status, root: :invitation)
      else
        render_json_error({ message: result.message }, result.status)
      end
    end

    def destroy
      authorize @invitation
      if @invitation.destroy
        head :no_content
      else
        render_json_error({ message: 'Could not revoke an invitation' }, :bad_request)
      end
    end

    def accept
      get_resource
      result = BeachApiCore::InvitationAccept.call(invitation: @invitation, token: params[:token],
                                                   application: @invitation.group.application,
                                                   user: @invitation.invitee)
      if result.success?
        render_json_success(result.access_token&.token, result.status)
      else
        render_json_error({ message: result.message }, result.status)
      end
    end

    private

    def invitation_params
      params.require(:invitation).permit(:email, :first_name, :last_name, role_ids: [])
    end
  end
end
