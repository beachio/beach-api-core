module BeachApiCore::UserInteractor
  class CreateResetToken
    include Interactor

    def call
      if context.user.nil?
        context.status = :bad_request
        context.fail! message: I18n.t('interactors.errors.invalid_email')
      elsif context.user.update(reset_password_token: SecureRandom.urlsafe_base64)
        context.status = :ok
      else
        context.status = :bad_request
        context.fail! message: context.user.errors.full_messages
      end
    end
  end
end
