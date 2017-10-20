module BeachApiCore
  class PlanItem < ApplicationRecord
    belongs_to :plan
    belongs_to :access_level

    validates :users_count, :access_level, :plan, presence: true
    validates :access_level, uniqueness: { scope: :plan_id }
  end
end
