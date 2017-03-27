module BeachApiCore
  class InteractionAttributeSerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern
    acts_as_abs_doc_id

    attributes :id, :key, :values
  end
end
