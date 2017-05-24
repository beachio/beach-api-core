module BeachApiCore::InvitationInteractor
  class Accept
    include Interactor

    def call
      invitation = BeachApiCore::Invitation.find_by(token: context.token)
      if context.invitation != invitation
        context.status = :bad_request
        context.fail! message: I18n.t('interactors.errors.incorrect_token')
      elsif context.invitation.accept!
        context.status = :ok
      else
        context.status = :bad_request
        context.fail! message: context.invitation.errors.full_messages
      end
    end
  end
end
