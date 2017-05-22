class BeachApiCore::ResetPassword
  include Interactor

  before do
    context.user = BeachApiCore::User.find_by(reset_password_token: context.params[:token])
  end
  
  def call
    unless context.user
      context.status = :bad_request
      context.fail! message: 'Invalid token'
    end
    context.user.require_confirmation = true
    if context.user.update context.params.slice(:password, :password_confirmation)
      context.user.update(reset_password_token: nil)
      context.status = :ok
    else
      context.status = :bad_request
      context.fail! message: context.user.errors.full_messages
    end
  end
end
