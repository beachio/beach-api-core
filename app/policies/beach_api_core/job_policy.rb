module BeachApiCore
  class JobPolicy < ApplicationPolicy
    def show?
      record.application == application
    end

    def destroy?
      record.application == application
    end
  end
end
