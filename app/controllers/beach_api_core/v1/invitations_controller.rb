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
              redirect_to success_v1_invitation_path(group_type: @invitation.group.class.to_s, group_name: @invitation.group.name, application_id: @invitation.group.application.id)
            end
          else
            if request.format.symbol != :html
              render_json_error({ message: result.message }, result.status)
            else
              @user = @invitation.invitee
              @group = {:name => invitation.group.name, type: invitation.group.class.to_s.gsub("BeachApiCore::", "").downcase}
              application = invitation.group.application
              create_config(application)
              @result = {:status => 'fail', message: result.message.is_a?(String) ? [result.message] : result.message}
              render :accept_invitation
            end
          end
        else
          @user = @invitation.invitee
          @group = {:name => invitation.group.name, type: invitation.group.class.to_s.gsub("BeachApiCore::", "").downcase}
          application = invitation.group.application
          create_config(application)
          @result = {:status => 'fail', message: ["Password confirmation doesn't match Password"]}
          render :accept_invitation
        end
      end
    end

    def success
      group_name = params[:group_name].nil? ? "" : params[:group_name]
      group_type = params[:group_type].nil? ? "team" : params[:group_type].gsub("BeachApiCore::","").downcase
      @group = {:name => group_name, type:  group_type}
      application = Doorkeeper::Application.where(id: params[:application_id]).first
      create_config(application)
      @config[:third_margin] = @config[:success_button_first_available] || @config[:success_button_second_available]
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
          @group = {:name => invitation.group.name, type: invitation.group.class.to_s.gsub("BeachApiCore::","").downcase}
          application = invitation.group.application
          create_config(application)
        end
      else
        head :no_content
      end
    end

    private

    def invitation_params
      params.require(:invitation).permit(:email, :first_name, :last_name, role_ids: [])
    end

    def create_config(application)
      custom_view = application.nil? ? nil : application.custom_views.where(:view_type => 0).first
      background_image = application.nil? || application.background_image.nil? || application.background_image.empty? ? "" : "background-image:url(#{application.background_image}); background-size:cover;"
      background_color = application.nil? || application.background_color.nil? || application.background_color.empty? ? "background-color: #{BeachApiCore::Instance.background_color};" : "background-color: #{application.background_color}"
      background = application.nil? || application.use_default_background_config ? "#{BeachApiCore::Instance.background_image}background-color:#{BeachApiCore::Instance.background_color};"  : "#{background_image}#{background_color}"
      @config = {
          show_application_logo: application.nil? || application.show_application_logo.nil? ? BeachApiCore::Instance.show_application_logo : application.show_application_logo,
          show_instance_logo:  application.nil? || application.show_instance_logo.nil? ? BeachApiCore::Instance.show_instance_logo : application.show_instance_logo,
          provided_text_color: application.nil? || application.provided_text_color.empty? || application.provided_text_color.nil? ? BeachApiCore::Instance.provided_text_color : application.provided_text_color,
          application_logo: application.nil? || application.application_logo_url.nil? || application.application_logo_url.empty? ? BeachApiCore::Instance.application_logo : application.application_logo_url,
          body_style: background,
          provided_by: BeachApiCore::Setting.provided_by_text(keeper: BeachApiCore::Instance.current).nil? ? BeachApiCore::Instance.provided_by_text : BeachApiCore::Setting.provided_by_text(keeper: BeachApiCore::Instance.current)
      }
        @config[:input_style]                 =  custom_view.nil? || custom_view.input_style.nil? || custom_view.input_style.empty? ? BeachApiCore::Instance.input_style : custom_view.input_style.gsub("\n", "")
        @config[:header_text]                 =  custom_view.nil? || custom_view.header_text.nil? || custom_view.header_text.empty? ? BeachApiCore::Instance.invite_text : custom_view.header_text.gsub("\n", "<br>")
        @config[:text_color]                  =  custom_view.nil? || custom_view.text_color.nil? || custom_view.text_color.empty? ? BeachApiCore::Instance.text_color    : custom_view.text_color
        @config[:success_text_color]          =  custom_view.nil? || custom_view.success_text_color.nil? || custom_view.success_text_color.empty? ? BeachApiCore::Instance.success_text_color    : custom_view.success_text_color
        @config[:form_background_color]       =  custom_view.nil? || custom_view.form_background_color.nil? || custom_view.form_background_color.empty? ? BeachApiCore::Instance.form_background_color : custom_view.form_background_color
        @config[:success_text]                =  custom_view.nil? || custom_view.success_text.nil? || custom_view.success_text.empty? ? BeachApiCore::Instance.success_invitation_text : custom_view.success_text.gsub("\n", "<br>")
        @config[:success_background_color]    =  custom_view.nil? || custom_view.success_background_color.nil? || custom_view.success_background_color.empty? ? BeachApiCore::Instance.success_invitation_background : custom_view.success_background_color
        @config[:form_radius]                 =  custom_view.nil? || custom_view.form_radius.nil? || custom_view.form_radius.empty? ? "0px" : custom_view.form_radius
        @config[:success_form_radius]         =  custom_view.nil? || custom_view.success_form_radius.nil? || custom_view.success_form_radius.empty? ? BeachApiCore::Instance.invitation_success_form_radius : custom_view.success_form_radius
        @config[:button_text]                 =  custom_view.nil? || custom_view.button_text.nil? || custom_view.button_text.empty? ? BeachApiCore::Instance.invite_button_text : custom_view.button_text
        @config[:button_style]                =  custom_view.nil? || custom_view.button_style.nil? || custom_view.button_style.empty? ? BeachApiCore::Instance.button_style : custom_view.button_style
        @config[:error_text_color]            =  custom_view.nil? || custom_view.error_text_color.nil? || custom_view.error_text_color.empty? ? "red"    : custom_view.error_text_color
        @config[:first_icon]                  =  custom_view.nil? || custom_view.success_button_first_icon_type.nil? || custom_view.success_button_first_icon_type.empty? ? BeachApiCore::Instance.success_invitation_first_icon_type : custom_view.success_button_first_icon_type
        @config[:second_icon]                 =  custom_view.nil? || custom_view.success_button_second_icon_type.nil? || custom_view.success_button_second_icon_type.empty? ? BeachApiCore::Instance.success_invitation_second_icon_type : custom_view.success_button_second_icon_type
        @config[:third_icon]                  =  custom_view.nil? || custom_view.success_button_third_icon_type.nil? || custom_view.success_button_third_icon_type.empty? ? BeachApiCore::Instance.success_invitation_third_icon_type : custom_view.success_button_third_icon_type
        @config[:first_btn_text]              =  custom_view.nil? || custom_view.success_button_first_text.nil? || custom_view.success_button_first_text.empty? ? BeachApiCore::Instance.success_invitation_first_button_text : custom_view.success_button_first_text
        @config[:second_btn_text]             =  custom_view.nil? || custom_view.success_button_second_text.nil? || custom_view.success_button_second_text.empty? ? BeachApiCore::Instance.success_invitation_second_button_text : custom_view.success_button_second_text
        @config[:third_btn_text]              =  custom_view.nil? || custom_view.success_button_third_text.nil? || custom_view.success_button_third_text.empty? ? BeachApiCore::Instance.success_invitation_third_button_text : custom_view.success_button_third_text
        @config[:first_link]                  =  custom_view.nil? || custom_view.success_button_first_link.nil? || custom_view.success_button_first_link.empty? ? BeachApiCore::Instance.success_invitation_first_button_link : custom_view.success_button_first_link
        @config[:second_link]                 =  custom_view.nil? || custom_view.success_button_second_link.nil? || custom_view.success_button_second_link.empty? ? BeachApiCore::Instance.success_invitation_second_button_link : custom_view.success_button_second_link
        @config[:third_link]                  =  custom_view.nil? || custom_view.success_button_third_link.nil? || custom_view.success_button_third_link.empty? ? BeachApiCore::Instance.success_invitation_third_button_link : custom_view.success_button_third_link
        @config[:success_button_style]        =  custom_view.nil? || custom_view.success_button_style.nil? || custom_view.success_button_style.empty? ? BeachApiCore::Instance.success_invitation_button_style : custom_view.success_button_style
        @config[:success_button_first_available]        =  custom_view.nil? || custom_view.success_button_first_available.nil? ? BeachApiCore::Instance.success_button_first_available : custom_view.success_button_first_available
        @config[:success_button_second_available]       =  custom_view.nil? || custom_view.success_button_second_available.nil? ? BeachApiCore::Instance.success_button_second_available : custom_view.success_button_second_available
        @config[:success_button_third_available]        =  custom_view.nil? || custom_view.success_button_third_available.nil? ? BeachApiCore::Instance.success_button_third_available : custom_view.success_button_third_available
        button_count = 0
        [@config[:success_button_first_available], @config[:success_button_second_available], @config[:success_button_third_available]  ].each {|conf| button_count += 1 if conf}
        if button_count == 1
          @config[:button_width] = "519px"
          @config[:margin] = "20px"
        elsif button_count == 2
          @config[:button_width] = "249.5px"
          @config[:margin] =  "8px"
        else
          @config[:button_width] =  "155px"
          @config[:margin] = "5px"
        end
    end
  end
end
