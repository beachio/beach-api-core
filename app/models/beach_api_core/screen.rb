module BeachApiCore
  class Screen < ApplicationRecord
    belongs_to :resource, polymorphic: true
    has_paper_trail
  end
end
