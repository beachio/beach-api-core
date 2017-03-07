module BeachApiCore
  class InteractionAttributeSerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern

    attributes :id, :key, :values
  end
end
