module BeachApiCore
  class OrganisationPolicy < ApplicationPolicy
    def show?
      user.organisation == record
    end

    def update?
      organisation_owner?
    end
    alias destroy? update?

    private

    def organisation_owner?
      record.owners.include?(user)
    end
  end
end