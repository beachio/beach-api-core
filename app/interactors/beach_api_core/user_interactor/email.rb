module BeachApiCore::UserInteractor
  class Email
    include Interactor

    def call
      BeachApiCore::UserMailer.register_confirm(context.user).deliver_now
    end
  end
end
