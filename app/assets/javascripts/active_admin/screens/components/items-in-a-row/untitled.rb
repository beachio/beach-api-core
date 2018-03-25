BeachApiCore::Screen.find_each do |screen|
  screen.content["body"].each do |t|
    if t["type"] == 'items-in-a-row'
      list = []
      t["settings"]["list"].each do |el|
        list << {states: [el]}
      end
      t["settings"]["list"] = list
      screen.save
    end
  end
end

BeachApiCore::Screen.find_each do |screen|
  screen.content["header"]["settings"] = {states: [screen.content["header"]["settings"]]}

  screen.content["body"].each do |t|
    t["settings"] = {states: [t["settings"]]}
  end
  screen.content["footer"].each do |t|
    t["settings"] = {states: [t["settings"]]}
  end
  screen.save
end