module BeachApiCore::InvitationInteractor
  class Email
    include Interactor

    def call
      BeachApiCore::InvitationMailer.group_invite(context.invitation).deliver_later
    end
  end
end
