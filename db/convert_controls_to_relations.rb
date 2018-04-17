BeachApiCore::Screen::Control.delete_all
BeachApiCore::ScreensControl.delete_all
BeachApiCore::Screen.all.each do |screen|
  screen.content.each do |section, controls|
    if controls.is_a?(Array)
      controls.each_with_index do |control, index|
        screen.controls.create(settings: control["settings"], position: index, section: section)
      end
    elsif controls.is_a?(Hash)
      screen.controls.create(settings: controls, position: 0, section: section)
    end
  end
end