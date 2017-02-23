module BeachApiCore
  class InteractionAttributeSerializer < ActiveModel::Serializer
    attributes :id, :key, :values
  end
end
