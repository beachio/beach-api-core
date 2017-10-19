module BeachApiCore
  class UserAccess < ApplicationRecord
    belongs_to :keeper, polymorphic: true
    belongs_to :access_level, inverse_of: :user_accesses
    belongs_to :user, inverse_of: :user_accesses

    validates :access_level, :user, :keeper, presence: true
    validates :user, uniqueness: { scope: %i(access_level_id keeper_id keeper_type) }
  end
end
