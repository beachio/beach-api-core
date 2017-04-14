module BeachApiCore
  class AssignmentSerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern
    acts_as_abs_doc_id

    attributes :id, :keeper_id, :keeper_type, :role_id
    belongs_to :user, serializer: BeachApiCore::UserSimpleSerializer
  end
end
