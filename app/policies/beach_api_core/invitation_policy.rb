module BeachApiCore
  class InvitationPolicy < ApplicationPolicy
    def destroy?
      record.user == user
    end
  end
end
