ActiveAdmin.register_page 'Sessions' do
  menu false

  page_action :new, method: :get do
    render :new
  end

  page_action :create, method: :post do
    result = BeachApiCore::SignIn.call(session_params.merge(skip_headers: true))
    if result.success?
      session[:user_id] = result.user.id
      redirect_to admin_root_path
    else
      flash[:error] = t('admin.errors.invalid_email_or_password')
      render :new
    end
  end

  page_action :destroy, method: :delete do
    session[:user_id] = nil
    redirect_to admin_root_path
  end

  controller do
    protect_from_forgery
    skip_before_action :authenticate_active_admin_user
    skip_before_action :authorize_access!

    layout 'active_admin_logged_out'

    def index
      redirect_to admin_sessions_new_path
    end

    private

    def session_params
      params.require(:session).permit(:email, :password)
    end
  end
end
