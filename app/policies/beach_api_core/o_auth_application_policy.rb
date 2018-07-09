module BeachApiCore
  class OAuthApplicationPolicy < ApplicationPolicy
    def show?
      record.owner == user
    end

    def manage?
      show? || ::Pundit.policy(user, Instance.current).developer_or_admin?
    end

    alias update? show?
    alias destroy? show?
  end
end
