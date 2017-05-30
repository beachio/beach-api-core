module BeachApiCore
  class WebhookPolicy < ApplicationPolicy
    def destroy?
      record.application == application
    end
  end
end
