module BeachApiCore
  class OrganisationPlan < ApplicationRecord
    belongs_to :organisation
    belongs_to :plan

    validates :organisation, :plan, presence: true
  end
end
