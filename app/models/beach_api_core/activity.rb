module BeachApiCore
  class Activity < ApplicationRecord
    belongs_to :user
    belongs_to :affected
    belongs_to :origin
    belongs_to :destination
  end
end
