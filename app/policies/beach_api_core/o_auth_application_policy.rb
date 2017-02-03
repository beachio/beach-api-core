module BeachApiCore
  class OAuthApplicationPolicy < ApplicationPolicy
    def show?
      record.owner == user
    end

    def manage?
      show? || ::Pundit.policy(user, Instance.current).developer_or_admin?
    end

    alias_method :update?, :show?
    alias_method :destroy?, :show?
  end
end