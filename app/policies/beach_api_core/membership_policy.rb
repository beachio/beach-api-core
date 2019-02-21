module BeachApiCore
  class MembershipPolicy < ApplicationPolicy
    def destroy?
      group_owner? or group_admin?
    end

    private

    def group_owner?
      record.group.owners.include?(user)
    end

    def group_admin?
      record.group.assignments.admins.find_by(user_id: user.id) rescue false
    end
  end
end
