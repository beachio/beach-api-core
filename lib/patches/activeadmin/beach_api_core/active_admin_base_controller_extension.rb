module BeachApiCore::ActiveAdminBaseControllerExtension
  extend ActiveSupport::Concern

  included do
    def authenticate_admin_user!
      return redirect_to(admin_sessions_new_path) unless user_signed_in?
      return if current_user&.admin? || current_user&.scientist? || current_user&.editor?
      session[:user_id] = nil
      flash[:alert] = I18n.t('errors.not_authorized')
      redirect_to admin_root_path
    end

    def user_signed_in?
      session[:user_id].present?
    end

    def current_user
      @current_user ||= BeachApiCore::User.find_by(id: session[:user_id])
    end

    def access_denied(_e)
      redirect_to(admin_sessions_new_path)
    end
  end
end
