module BeachApiCore
  class MembershipPolicy < ApplicationPolicy
    def destroy?
      group_owner?
    end

    private

    def group_owner?
      record.group.owners.include?(user)
    end
  end
end