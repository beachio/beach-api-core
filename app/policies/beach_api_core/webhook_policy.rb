module BeachApiCore
  class WebhookPolicy < ApplicationPolicy
    def destroy?
      record.keeper == application
    end
  end
end
