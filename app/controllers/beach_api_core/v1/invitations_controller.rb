module BeachApiCore
  class V1::InvitationsController < BeachApiCore::V1::BaseController
    include BeachApiCore::Concerns::V1::GroupResourceConcern
    include BeachApiCore::Concerns::V1::ResourceConcern
    include InvitationsDoc
    before_action :doorkeeper_authorize!, except: [:accept, :accept_invitation, :success]
    before_action :find_group, except: [:destroy]
    skip_before_action :find_group, only: [:accept, :accept_invitation, :success]

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
      invitation = BeachApiCore::Invitation.where(:id => params[:id]).first
      if invitation.nil?
        if request.format.symbol != :html
          render_json_error({ message: ["Wrong Invitation"] }, result.status)
        else
          @user = invitation.invitee
          @result = {:status => 'fail', message: ["Wrong Invitation"]}
          render :accept_invitation
        end
      else
        @invitation = invitation
        confirmed = @invitation.invitee.confirmed?
        check = request.format.symbol == :html && !confirmed ? params[:invitation][:password] == params[:invitation][:password_confirmation] : true
        if check
          result = BeachApiCore::InvitationAccept.call(invitation: @invitation, token: params[:token],
                                                       application: @invitation.group.application,
                                                       user: @invitation.invitee)
          if result.success?
            if request.format.symbol != :html
              render_json_success({ access_token: result.access_token&.token }, result.status)
            else
              @invitation.invitee.update_attribute(:password, params[:invitation][:password] ) unless confirmed
              redirect_to success_v1_invitation_path(group_type: @invitation.group.class.to_s, group_name: @invitation.group.name)
            end
          else
            if request.format.symbol != :html
              render_json_error({ message: result.message }, result.status)
            else
              @user = @invitation.invitee
              @result = {:status => 'fail', message: result.message.is_a?(String) ? [result.message] : result.message}
              render :accept_invitation
            end
          end
        else
          @user = @invitation.invitee
          @result = {:status => 'fail', message: ["Password confirmation doesn't match Password"]}
          render :accept_invitation
        end
      end
    end

    def success
      @group_name = params[:group_name]
      @group_type = params[:group_type].nil? ? "team" : params[:group_type].gsub("BeachApiCore::","").downcase
    end

    def accept_invitation
      if request.format.symbol == :html
        invitation = BeachApiCore::Invitation.where(:token => params[:token]).first
        @result = {:status => 'accept_invitation', message: []}
        if invitation.nil?
          @user = BeachApiCore::User.new
          @result = {:status => 'wrong_token', message: ["Wrong invitation token"]}
        elsif invitation.invitee.confirmed?
          redirect_to accept_v1_invitation_path(id: invitation.id, token: params[:token])
        else
          @user = invitation.invitee
          @group = invitation.group.name
        end
      else
        head :no_content
      end
    end

    private

    def invitation_params
      params.require(:invitation).permit(:email, :first_name, :last_name, role_ids: [])
    end
  end
end
