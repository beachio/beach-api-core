module BeachApiCore
  class OrganisationPolicy < ApplicationPolicy
    def show?
      user.organisations.include?(record)
    end

    def update?
      organisation_owner? || admin?
    end
    alias destroy? update?

    private

    def organisation_owner?
      record.owners.include?(user)
    end

    def admin?
      user.role?(Role.admin, record)
    end
  end
end
