module BeachApiCore
  class OrganisationPolicy < ApplicationPolicy
    def show?
      user.organisations.include?(record)
    end

    def update?
      organisation_owner?
    end
    alias destroy? update?
    alias manage_invitations? update?

    private

    def organisation_owner?
      record.owners.include?(user)
    end
  end
end
