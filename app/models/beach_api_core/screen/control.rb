module BeachApiCore
  class Screen::Control < ApplicationRecord
    attr_accessor :position, :section

    has_many :screens_controls
    has_many :screens, through: :screens_controls
  end
end
