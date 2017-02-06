module BeachApiCore::UserInteractor
  class Email
    include Interactor

    def call
      BeachApiCore::UserMailer.register_confirm(context.user).deliver_later
    end
  end
end
