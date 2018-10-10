class BeachApiCore::Authorization::AuthorizeUser
  include Interactor

  before do
    if context.email.blank?
      context.status = :bad_request
      context.fail! message: [I18n.t('interactors.errors.email_must_be_present')]
    end

    if context.password.blank?
      context.status = :bad_request
      context.fail! message: [I18n.t('interactors.errors.password_must_be_present')]
    end
  end

  def call
    if (user&.authenticate context.password) && user&.confirmed?
      context.user = user
      context.status = :ok
    else
      context.status = :unauthorized
      context.fail! message: (user&.authenticate context.password) ? ["Your account is not verified"] :  [I18n.t('interactors.errors.not_valid_email_or_password')]
    end
  end

  private

  def user
    @_user ||= BeachApiCore::User.find_by(email: context.email.downcase)
  end
end
