module BeachApiCore::Concerns::UserRoles
  extend ActiveSupport::Concern

  included do
    has_many :assignments, inverse_of: :user, dependent: :destroy
    has_many :roles, through: :assignments

    scope :with_role, -> (*roles) { includes(:roles).where(roles: { name: roles }) }
  end

  def has_role?(role, keeper = nil)
    assignments.where(role: role, keeper: keeper || BeachApiCore::Instance.current).present?
  end

  def add_role(role, keeper = nil)
    assignments.create(role: role, keeper: keeper || BeachApiCore::Instance.current)
  end
end
