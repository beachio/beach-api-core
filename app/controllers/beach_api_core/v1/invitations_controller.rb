module BeachApiCore
  class V1::InvitationsController < BeachApiCore::V1::BaseController
    include BeachApiCore::Concerns::V1::GroupResourceConcern
    include BeachApiCore::Concerns::V1::ResourceConcern
    include InvitationsDoc
    before_action :doorkeeper_authorize!, except: [:accept]
    before_action :find_group, except: [:destroy]
    skip_before_action :find_group, only: :accept

    resource_description do
      name I18n.t('activerecord.models.beach_api_core/invitation.other')
      error code: 403, desc: I18n.t('api.resource_description.errors.forbidden_request')
      error code: 401, desc: I18n.t('api.resource_description.errors.unauthorized')
      error code: 400, desc: I18n.t('api.resource_description.errors.bad_request')
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
                                                   application: current_application,
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
        render_json_error({ message: I18n.t('api.errors.could_not_revoke_invitation') }, :bad_request)
      end
    end

    def accept
      get_resource
      result = BeachApiCore::InvitationAccept.call(invitation: @invitation, token: params[:token],
                                                   application: @invitation.group.application,
                                                   user: @invitation.invitee)
      if result.success?
        render_json_success({ access_token: result.access_token&.token }, result.status)
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
