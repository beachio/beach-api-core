module BeachApiCore
  class ProjectPolicy < ApplicationPolicy
    def update?
      record.user == user
    end
    alias destroy? update?
  end
end
