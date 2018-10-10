module BeachApiCore
  class V1::UsersController < BeachApiCore::V1::BaseController
    include ::UsersDoc
    before_action :doorkeeper_authorize!, only: %i(update show)
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
          render :activate_account
        else
          render_json_error({ message: "There are no such user" })
        end
      else
        check = request.format.symbol == :html ? params[:password] == params[:password_confirmation] : true
        if check
          result = BeachApiCore::UserInteractor::Confirm.call(user: user, token: params[:confirmation_token])
          user.update_attribute(:password, params[:password])
          if result.success?
            if request.format.symbol == :html
              render :success
            else
              render_json_success(result.user, :ok,
                                  serializer: BeachApiCore::UserSimpleSerializer,
                                  root: :user)
            end
          else
            if request.format.symbol == :html
              result.message  = result.message.is_a?(String) ? [result.message] : result.message
              @user = user
              @result = {:status => 'confirm_request', message: result.message}
              render :activate_account
            else
              render_json_error({ message: result.message }, result.status)
            end
          end
        else
          @user = user
          @result = {:status => 'confirm_request', message: ["Password confirmation doesn't match Password"]}
          render :activate_account
        end
      end
    end

    def activate_account
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
    end

    private

    def user_create_params
      params.require(:user).permit!
    end

    def user_update_params
      profile_attributes = custom_profile_fields.concat([:id, :first_name,
                                                         :last_name, :sex, :birth_date, :current_age,
                                                         avatar_attributes: %i(file base64)])
      params.require(:user).permit(:email, :username, :current_password, :password, :password_confirmation,
                                   profile_attributes: profile_attributes,
                                   user_preferences_attributes: [:id, preferences: preferences_params])
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
