module BeachApiCore
  class SimpleInteractionSerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern
    acts_as_abs_doc_id

    attributes :id, :kind, :created_at
    belongs_to :user, serializer: BeachApiCore::UserSimpleSerializer
    has_many :interaction_keepers
    has_many :interaction_attributes
  end
end
