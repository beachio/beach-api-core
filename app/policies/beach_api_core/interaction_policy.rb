module BeachApiCore
  class InteractionPolicy < ApplicationPolicy
    def update?
      interaction_user?
    end
    alias destroy? update?

    private

    def interaction_user?
      record.user == user
    end
  end
end
