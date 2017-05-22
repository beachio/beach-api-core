module BeachApiCore
  class InstancePolicy < ApplicationPolicy
    def developer?
      user.role?(Role.developer, record)
    end

    def admin?
      user.role?(Role.admin, record)
    end

    def developer_or_admin?
      developer? || admin?
    end
  end
end
