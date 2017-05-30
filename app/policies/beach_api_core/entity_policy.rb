module BeachApiCore
  class EntityPolicy < ApplicationPolicy
    def show?
      record.user == user
    end

    def destroy?
      record.user == user
    end
  end
end
