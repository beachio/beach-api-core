require_dependency "beach_api_core/application_controller"
module BeachApiCore
  class Admin::RedirectController < BeachApiCore::ApplicationController

    def index
      if current_user
        return redirect_to "/admin/users" if current_user.admin?
        return redirect_to "/admin/nutrients" if current_user.scientist?
        return redirect_to "/admin/flows" if current_user.editor?
      else
        return redirect_to "/admin/sessions/new"
      end
    end

  end
end
