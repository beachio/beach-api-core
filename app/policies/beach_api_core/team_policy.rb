module BeachApiCore
  class TeamPolicy < ApplicationPolicy
    def show?
      user.teams.exists?(id: record) || team_owner?
    end

    def update?
      team_owner?
    end
    alias destroy? update?

    private

    def team_owner?
      record.owners.include?(user)
    end
  end
end