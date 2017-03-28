module BeachApiCore
  class InvitationPolicy < ApplicationPolicy
    def destroy?
      record.user == user || group_owner?
    end

    private

    def group_owner?
      record.group.owners.include?(user)
    end
  end
end
