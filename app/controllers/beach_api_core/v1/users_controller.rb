module BeachApiCore
  class V1::UsersController < BeachApiCore::V1::BaseController
    include ::UsersDoc
    before_action :doorkeeper_authorize!, only: %i(update show, force_confirm_user)
    before_action :application_authorize!, only: %i(create)
    before_action :authenticate_service_for_doorkeeper_application, only: [:create]
    before_action :authenticate_service_for_application, only: %i(update show)
    resource_description do
      name I18n.t('activerecord.models.beach_api_core/user.other')
    end

    def create
      result = BeachApiCore::SignUp.call(user_create_params.merge(headers: request.headers['HTTP_AUTHORIZATION']))
      if result.success?
        render_json_success({ user: BeachApiCore::UserSerializer.new(result.user, root: :user),
                              access_token: result.access_token&.token }, result.status,
                            keepers: [Instance.current],
                            current_user: result.user,
                            root: :user)
      else
        render_json_error({ message: result.message }, result.status)
      end
    end

    def show
      render_json_success(current_user, :ok,
                          keepers: current_keepers,
                          current_user: current_user,
                          current_application: current_application,
                          root: :user)
    end

    def force_confirm_user
      if admin_or_application_admin(current_application.id)
        user = BeachApiCore::User.find_by(:id => params[:id])
        if user.nil?
          render_json_error({message: "Wrong user"})
        else
          render_json_success({message: "User with id: #{user.id} was successfully confirmed"})
        end
      else
        render_json_error({message: "Access Denied"})
      end
    end

    def update
      result = BeachApiCore::UserUpdate.call(user: current_user, params: user_update_params, keepers: current_keepers)
      if result.success?
        render_json_success(current_user, result.status,
                            keepers: current_keepers,
                            current_user: current_user,
                            current_application: current_application,
                            root: :user)
      else
        render_json_error({ message: result.message }, result.status)
      end
    end

    def confirm
      user = BeachApiCore::User.where(id: params[:id]).first
      if user.nil?
        if request.format.symbol == :html
          @user = BeachApiCore::User.new
          @result = {:status => 'fail', message: ["There are no such user."]}
          application = Doorkeeper::Application.where(id: params[:application_id]).first
          create_config(application)
          render :activate_account
        else
          render_json_error({ message: "There are no such user" })
        end
      else
        check = request.format.symbol == :html && params[:proxy] ? params[:password] == params[:password_confirmation] : true
        if check
          result = BeachApiCore::UserInteractor::Confirm.call(user: user, token: params[:confirmation_token])
          application = Doorkeeper::Application.find_by(id: params[:application_id])
          user.update_attribute(:password, params[:password]) if request.format.symbol == :html && params[:proxy]
          BeachApiCore::Score.create(:application => application, :user => user, :scores => application.scores_for_sign_up) if request.format.symbol == :html
          if result.success?
            if request.format.symbol == :html
              redirect_to v1_users_success_path(application_id: params[:application_id])
            else
              render_json_success(result.user, :ok,
                                  serializer: BeachApiCore::UserSimpleSerializer,
                                  root: :user)
            end
          else
            if request.format.symbol == :html
              result.message  = result.message.is_a?(String) ? [result.message] : result.message
              @user = user
              application = Doorkeeper::Application.where(id: params[:application_id]).first
              create_config(application)
              @result = {:status => 'confirm_request', message: result.message}
              render :activate_account
            else
              render_json_error({ message: result.message }, result.status)
            end
          end
        else
          @user = user
          @result = {:status => 'confirm_request', message: ["Password confirmation doesn't match Password"]}
          application = Doorkeeper::Application.where(id: params[:application_id]).first
          create_config(application)
          render :activate_account
        end
      end
    end

    def activate_account
      application = Doorkeeper::Application.where(:id => params[:application_id]).first
      create_config(application)
      if params[:confirmation_token].nil? || params[:id].nil?
        @user = BeachApiCore::User.new
        @result = {:status => 'confirm_request', message: ["Wrong confirmation token"]}
      else
        @user = BeachApiCore::User.where(:id => params[:id]).first
        if @user.nil? || @user.confirm_email_token != params[:confirmation_token]
            @user = BeachApiCore::User.new
            @result = {:status => 'confirm_request', message: ["Wrong confirmation token"]}
        else
          @result = {:status => 'confirm_request', message: []}
        end
      end
    end

    def success
      application = Doorkeeper::Application.where(id: params[:application_id]).first
      create_config(application)
    end

    private

    def user_create_params
      params.require(:user).permit!
    end

    def create_config(application = nil)
      custom_view = application.nil? ? nil : application.custom_views.where(:view_type => 1).first
      background_image = application.nil? || application.background_image.nil? || application.background_image.empty? ? "" : "background-image:url(#{application.background_image}); background-size:cover;"
      background_color = application.nil? || application.background_color.nil? || application.background_color.empty? ? "background-color: #{BeachApiCore::Instance.background_color};" : "background-color: #{application.background_color};"
      background = application.nil? || application.use_default_background_config ? "#{BeachApiCore::Instance.background_image}background-color:#{BeachApiCore::Instance.background_color};" : "#{background_image}#{background_color}"
      @config = {
          show_application_logo: application.nil? || application.show_application_logo.nil? ? BeachApiCore::Instance.show_application_logo : application.show_application_logo,
          show_instance_logo:  application.nil? || application.show_instance_logo.nil? ? BeachApiCore::Instance.show_instance_logo : application.show_instance_logo,
          provided_text_color: application.nil? || application.provided_text_color.empty? || application.provided_text_color.nil? ? BeachApiCore::Instance.provided_text_color : application.provided_text_color,
          application_logo: application.nil? || application.application_logo_url.nil? || application.application_logo_url.empty? ? BeachApiCore::Instance.application_logo : application.application_logo_url,
          body_style: background
      }
      @config[:input_style]                 =  custom_view.nil? || custom_view.input_style.nil? || custom_view.input_style.empty? ? BeachApiCore::Instance.input_style : custom_view.input_style.gsub("\n", "")
      @config[:header_text]                 =  custom_view.nil? || custom_view.header_text.nil? || custom_view.header_text.empty? ? BeachApiCore::Instance.confirm_acc_text : custom_view.header_text.gsub("\n", "<br>")
      @config[:text_color]                  =  custom_view.nil? || custom_view.text_color.nil? || custom_view.text_color.empty? ? BeachApiCore::Instance.text_color    : custom_view.text_color
      @config[:success_text_color]          =  custom_view.nil? || custom_view.success_text_color.nil? || custom_view.success_text_color.empty? ? BeachApiCore::Instance.success_text_color    : custom_view.success_text_color
      @config[:form_background_color]       =  custom_view.nil? || custom_view.form_background_color.nil? || custom_view.form_background_color.empty? ? BeachApiCore::Instance.form_background_color : custom_view.form_background_color
      @config[:success_text]                =  custom_view.nil? || custom_view.success_text.nil? || custom_view.success_text.empty? ? BeachApiCore::Instance.success_restore_text : custom_view.success_text.gsub("\n", "<br>")
      @config[:success_background_color]    =  custom_view.nil? || custom_view.success_background_color.nil? || custom_view.success_background_color.empty? ? BeachApiCore::Instance.success_background_color : custom_view.success_background_color
      @config[:form_radius]                 =  custom_view.nil? || custom_view.form_radius.nil? || custom_view.form_radius.empty? ? BeachApiCore::Instance.form_confirm_border_radius : custom_view.form_radius
      @config[:success_form_radius]         =  custom_view.nil? || custom_view.success_form_radius.nil? || custom_view.success_form_radius.empty? ? BeachApiCore::Instance.success_confirm_border_radius : custom_view.success_form_radius
      @config[:button_text]                 =  custom_view.nil? || custom_view.button_text.nil? || custom_view.button_text.empty? ? BeachApiCore::Instance.confirm_button_text : custom_view.button_text
      @config[:button_style]                =  custom_view.nil? || custom_view.button_style.nil? || custom_view.button_style.empty? ? BeachApiCore::Instance.button_style : custom_view.button_style
      @config[:error_text_color]            =  custom_view.nil? || custom_view.error_text_color.nil? || custom_view.error_text_color.empty? ? "red"    : custom_view.error_text_color
    end

    def user_update_params
      profile_attributes = custom_profile_fields.concat([:id, :first_name,
                                                         :last_name, :sex, :birth_date, :current_age,
                                                         avatar_attributes: %i(file base64)])
      params.require(:user).permit(:email, :username, :current_password, :password, :password_confirmation,
                                   profile_attributes: profile_attributes,
                                   user_preferences_attributes: [:id, preferences: preferences_params])
    end

    def admin_or_application_admin(application_id)
      Doorkeeper::Application.find(application_id).admins.where(:id => current_user.id).empty? ? admin : true
    end

    def admin
      !BeachApiCore::Instance.current.admins.find_by(id: current_user.id).nil?
    end

    def preferences_params
      preferences_attributes = params.dig(:user, :user_preferences_attributes) || {}
      return [] if preferences_attributes.blank?
      preferences_attributes.each_with_object([]) do |elem, acc|
        elem[:preferences].each { |key, _| acc << key unless acc.include? key }
        acc
      end
    end

    def custom_profile_fields
      @_custom_fields ||= ProfileCustomField.where(keeper: current_keepers).pluck(:name)
    end
  end
end
