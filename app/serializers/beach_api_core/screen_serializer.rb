module BeachApiCore
  class ScreenSerializer < ActiveModel::Serializer
    attributes :id, :settings, :position, :controls

    def controls
      @controls = object.controls.map do |control|
        screens_control = control.screens_controls.find_by(screen_id: object.id)
        control.position = screens_control.position
        control.section = screens_control.section
        control
      end
      @controls = ActiveModel::Serializer::CollectionSerializer.new(@controls, serializer: BeachApiCore::ControlSerializer).as_json
      @controls.group_by{|c| c[:section]}
    end
  end
end
