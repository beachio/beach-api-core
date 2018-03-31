module BeachApiCore
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception

    helper_method :current_user

    private
      def authenticate_admin_user!
        return current_user && current_user.role?(BeachApiCore::Role.admin)
      end

      def current_user
        @current_user ||= NuweHealth::User.find(doorkeeper_token&.user&.id) rescue nil
      end
  end
end
