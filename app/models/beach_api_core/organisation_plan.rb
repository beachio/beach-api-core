module BeachApiCore
  class OrganisationPlan < ApplicationRecord
    belongs_to :organisation
    belongs_to :plan
  end
end
