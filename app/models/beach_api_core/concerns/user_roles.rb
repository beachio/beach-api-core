module BeachApiCore::Concerns::UserRoles
  extend ActiveSupport::Concern

  included do
    has_many :assignments, inverse_of: :user, dependent: :destroy
    has_many :roles, through: :assignments

    scope :with_role, -> (*roles) { includes(:roles).where(roles: { name: roles }) }
  end

  def has_role?(role, keeper = nil)
    roles.where(id: role, keeper: keeper || Instance.current).present?
  end
end
