module BeachApiCore
  class Screen < ApplicationRecord
    belongs_to :resource, polymorphic: true
  end
end
