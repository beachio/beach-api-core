class BeachApiCore::Authorization::AuthorizeUser
  include Interactor

  before do
    if context.email.blank?
      context.status = :bad_request
      context.fail! message: ['Email must be present']
    end

    if context.password.blank?
      context.status = :bad_request
      context.fail! message: ['Password must be present']
    end
  end

  def call
    if user.authenticate context.password
      context.user = user
      context.status = :ok
    else
      context.status = :unauthorized
      context.fail! message: ['The email or password you have provided is not valid']
    end
  end

  private

  def user
    @_user ||= BeachApiCore::User.find_by!(email: context.email)
  end

end

