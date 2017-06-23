module BeachApiCore
  class EntityPolicy < ApplicationPolicy
    def show?
      entity_user?
    end
    alias destroy? show?
    alias lookup? show?
    alias update? show?

    private

    def entity_user?
      record.user == user
    end
  end
end
