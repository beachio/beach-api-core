module BeachApiCore
  class OrganisationPlan < ApplicationRecord
    belongs_to :organisation
    belongs_to :plan

    validates :organisation, :plan, presence: true
    validates :organisation, uniqueness: { scope: :plan_id }
  end
end
