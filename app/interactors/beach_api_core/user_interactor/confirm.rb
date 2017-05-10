module BeachApiCore::UserInteractor
  class Confirm
    include Interactor

    def call
      if context.user.confirm_email!(context.token)
        context.status = :ok
      else
        context.status = :bad_request
        context.fail! message: 'Invalid token'
      end
    end
  end
end
