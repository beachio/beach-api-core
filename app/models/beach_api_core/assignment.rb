module BeachApiCore
  class Assignment < ApplicationRecord
    belongs_to :role, inverse_of: :assignments
    belongs_to :user, inverse_of: :assignments

    validates :role, :user, presence: true
    validates :user, uniqueness: { scope: :role_id }
  end
end
