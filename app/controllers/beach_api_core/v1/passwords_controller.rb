module BeachApiCore
  class V1::PasswordsController < BeachApiCore::V1::BaseController
    include PasswordsDoc
    before_action :explicit_application_with_user_authorize!, only: %i(update create)
    skip_before_action :explicit_application_with_user_authorize!, only: [:update], :if => proc {|c| request.format.symbol == :html}
    resource_description do
      name I18n.t('api.resource_description.resources.passwords')
    end

    def create
      user = BeachApiCore::User.find_by(email: params[:email])
      result = BeachApiCore::ForgotPassword.call(user: user,
                                                 headers: request.headers['HTTP_AUTHORIZATION'])
      if result.success?
        render_json_success(result.user, :ok,
                            serializer: BeachApiCore::UserSimpleSerializer,
                            root: :user)
      else
        render_json_error({ message: result.message }, result.status)
      end
    end

    def update
      result = BeachApiCore::ResetPassword.call(params: reset_password_params,
                                                headers: request.headers['HTTP_AUTHORIZATION'], request_symbol: request.format.symbol)
      if result.success?
        if request.format.symbol == :html
          @result = {:status => 'updated', message: []}
          create_config(Doorkeeper::Application.where(:id => params[:application_id]).first)
          redirect_to v1_password_success_path(application_id: params[:application_id])
        else
          render_json_success(result.user, :ok,
                              serializer: BeachApiCore::UserSimpleSerializer,
                              root: :user)
        end
      else
        if request.format.symbol == :html
          @user = BeachApiCore::User.new
          @result = {:status => 'fail', message: result.message.is_a?(String) ? [result.message] : result.message}
          create_config(Doorkeeper::Application.where(:id => params[:application_id]).first)
          @body_style = "background-color: #{BeachApiCore::Instance.background_color};"
          @body_style += BeachApiCore::Instance.background_image
          render :restore_password
        else
          render_json_error({ message: result.message }, result.status)
        end
      end
    end

    def success_restore
      application = Doorkeeper::Application.where(:id => params[:application_id]).first
      create_config(application)
    end

    def restore_password
      @user = BeachApiCore::User.new
      create_config(Doorkeeper::Application.where(:id => params[:application_id]).first)
      @result = {:status => 'restore_reuest', message: []}
    end

    def reset_password_params
      params.permit(:token, :password, :password_confirmation)
    end

    def create_config(application = nil)
      custom_view = application.nil? ? nil : application.custom_views.where(:view_type => 2).first
      background_image = application.nil? || application.background_image.nil? || application.background_image.empty? ? "" : "background-image:url(#{application.background_image}); background-size:cover;"
      background_color = application.nil? || application.background_color.nil? || application.background_color.empty? ? "background-color: #{BeachApiCore::Instance.background_color};" : "background-color: #{application.background_color};"
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
      @config[:header_text]                 =  custom_view.nil? || custom_view.header_text.nil? || custom_view.header_text.empty? ? BeachApiCore::Instance.restore_text : custom_view.header_text.gsub("\n", "<br>")
      @config[:text_color]                  =  custom_view.nil? || custom_view.text_color.nil? || custom_view.text_color.empty? ? BeachApiCore::Instance.text_color    : custom_view.text_color
      @config[:success_text_color]          =  custom_view.nil? || custom_view.success_text_color.nil? || custom_view.success_text_color.empty? ? BeachApiCore::Instance.success_text_color    : custom_view.success_text_color
      @config[:form_background_color]       =  custom_view.nil? || custom_view.form_background_color.nil? || custom_view.form_background_color.empty? ? BeachApiCore::Instance.form_background_color : custom_view.form_background_color
      @config[:success_text]                =  custom_view.nil? || custom_view.success_text.nil? || custom_view.success_text.empty? ? BeachApiCore::Instance.success_restore_text : custom_view.success_text.gsub("\n", "<br>")
      @config[:success_background_color]    =  custom_view.nil? || custom_view.success_background_color.nil? || custom_view.success_background_color.empty? ? BeachApiCore::Instance.success_invitation_background : custom_view.success_background_color
      @config[:form_radius]                 =  custom_view.nil? || custom_view.form_radius.nil? || custom_view.form_radius.empty? ? BeachApiCore::Instance.form_restore_border_radius : custom_view.form_radius
      @config[:success_form_radius]         =  custom_view.nil? || custom_view.success_form_radius.nil? || custom_view.success_form_radius.empty? ? BeachApiCore::Instance.success_restore_border_radius : custom_view.success_form_radius
      @config[:button_text]                 =  custom_view.nil? || custom_view.button_text.nil? || custom_view.button_text.empty? ? BeachApiCore::Instance.restore_button_text : custom_view.button_text
      @config[:button_style]                =  custom_view.nil? || custom_view.button_style.nil? || custom_view.button_style.empty? ? BeachApiCore::Instance.button_style : custom_view.button_style
      @config[:error_text_color]            =  custom_view.nil? || custom_view.error_text_color.nil? || custom_view.error_text_color.empty? ? "red"    : custom_view.error_text_color
    end
  end
end
