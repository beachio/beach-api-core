module BeachApiCore
  class EntityPolicy < ApplicationPolicy
    def show?
      entity_user?
    end
    alias destroy? show?
    alias lookup? show?
    alias create? show?
    alias index? show?

    private

    def entity_user?
      record.user == user
    end
  end
end
