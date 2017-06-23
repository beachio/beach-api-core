module BeachApiCore
  class EntityPolicy < ApplicationPolicy
    alias show? entity_user?
    alias destroy? entity_user?
    alias lookup? entity_user?
    alias create? entity_user?
    alias index? entity_user?

    private

    def entity_user?
      record.user == user
    end
  end
end
