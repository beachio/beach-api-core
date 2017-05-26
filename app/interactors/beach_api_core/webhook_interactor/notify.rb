module BeachApiCore::WebhookInteractor
  class Notify
    include Interactor

    def call
      return unless context.success?
      if context.team
        kind = 'team_created'
      elsif context.organisation
        kind = 'organisation_created'
      else
        kind = 'user_created'
      end
      BeachApiCore::Webhook.notify(kind)
    end
  end
end
