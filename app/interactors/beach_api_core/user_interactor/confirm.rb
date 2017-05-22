module BeachApiCore::UserInteractor
  class Confirm
    include Interactor

    def call
      if context.user.confirm_email!(context.token)
        context.status = :ok
      else
        context.status = :bad_request
        context.fail! message: t('interactors.errors.incorrect_token')
      end
    end
  end
end
