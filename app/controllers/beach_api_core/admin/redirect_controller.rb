require_dependency "beach_api_core/application_controller"
module BeachApiCore
  class Admin::RedirectController < BeachApiCore::ApplicationController
    before_action :authenticate_admin_user!

    def index
      return redirect_to "/admin/users" if current_user.admin?
      return redirect_to "/admin/nutrients" if current_user.scientist?
      return redirect_to "/admin/flows" if current_user.editor?
    end

  end
end