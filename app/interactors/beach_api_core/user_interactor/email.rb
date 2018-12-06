module BeachApiCore::UserInteractor
  class Email
    include Interactor

    def call
      return if context.user.confirmed?
      BeachApiCore::UserMailer.register_confirm(context.application, context.user, false).deliver_later
    end
  end
end
