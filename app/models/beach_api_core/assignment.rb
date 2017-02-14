module BeachApiCore
  class Assignment < ApplicationRecord
    belongs_to :keeper, polymorphic: true
    belongs_to :role, inverse_of: :assignments
    belongs_to :user, inverse_of: :assignments

    validates :role, :user, :keeper, presence: true
    validates :user, uniqueness: { scope: [:role_id, :keeper_id, :keeper_type] }

    scope :developers, -> { where(role: BeachApiCore::Role.developer) }
    scope :admins, -> { where(role: BeachApiCore::Role.admin) }
  end
end
