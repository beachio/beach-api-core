module BeachApiCore
  class InstancePolicy < ApplicationPolicy
    def developer?
      user.has_role?(Role.developer, record)
    end

    def admin?
      user.has_role?(Role.admin, record)
    end

    def developer_or_admin?
      developer? || admin?
    end
  end
end