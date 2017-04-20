module BeachApiCore
  class SimpleAssignmentSerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern
    acts_as_abs_doc_id

    attributes :id
    belongs_to :role
  end
end
