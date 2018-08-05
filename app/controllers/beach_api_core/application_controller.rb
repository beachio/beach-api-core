module BeachApiCore
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    before_action :set_paper_trail_whodunnit

    helper_method :current_user

    def test
      render template: "layouts/test"
    end

    private
      def authenticate_admin_user!
        return current_user && (
          current_user.admin? || current_user.scientist? || current_user.editor?
        )
      end

      def current_user
        @current_user ||= BeachApiCore::User.find(doorkeeper_token&.user&.id || session["user_id"]) rescue nil
      end
  end
end
