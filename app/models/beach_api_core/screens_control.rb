module BeachApiCore
  class ScreensControl < ApplicationRecord
    belongs_to :screen
    belongs_to :control, class_name: "BeachApiCore::Screen::Control"
    before_create :set_position
    before_create :set_section

    private
    def set_position
      self.position = control.position
    end

    def set_section
      self.section = control.section
    end
  end
end
