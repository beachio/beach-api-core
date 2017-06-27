module BeachApiCore
  class EntityPolicy < ApplicationPolicy
    def show?
      entity_user?
    end
    alias index? show?
    alias create? show?
    alias destroy? show?
    alias lookup? show?
    alias update? show?

    private

    def entity_user?
      record.user == user
    end
  end
end
