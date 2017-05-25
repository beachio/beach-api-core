module BeachApiCore
  class EntityPolicy < ApplicationPolicy
    def destroy?
      record.user == user
    end
  end
end
