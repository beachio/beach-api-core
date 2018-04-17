module BeachApiCore
  class Screen < ApplicationRecord
    belongs_to :resource, polymorphic: true
    has_many :screens_controls
    has_many :controls, ->{order("beach_api_core_screens_controls.position")}, through: :screens_controls
  end
end
