module BeachApiCore
  class ControlSerializer < ActiveModel::Serializer
    attributes :id, :settings, :position, :section
  end
end
