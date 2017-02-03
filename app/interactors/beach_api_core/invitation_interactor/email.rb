module BeachApiCore::InvitationInteractor
  class Email
    include Interactor

    def call
      # TODO: add mailer
      # InvitationMailer.group_invite(context.invitation).deliver_later
    end
  end
end
