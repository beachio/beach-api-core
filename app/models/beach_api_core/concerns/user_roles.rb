module BeachApiCore::Concerns::UserRoles
  extend ActiveSupport::Concern

  included do
    has_many :assignments, inverse_of: :user, dependent: :destroy
    has_many :roles, through: :assignments

    scope :with_role, -> (*roles) { includes(:assignments).where(beach_api_core_assignments: { role_id: roles }) }

    def has_role?(role, keeper = nil)
      assignments.where(role: role, keeper: keeper || BeachApiCore::Instance.current).present?
    end

    def add_role(role, keeper = nil)
      assignments.create(role: role, keeper: keeper || BeachApiCore::Instance.current)
    end
  end
end
