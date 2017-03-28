module BeachApiCore
  class SimpleInteractionSerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern
    acts_as_abs_doc_id

    attributes :id, :kind, :created_at
    belongs_to :user
    has_many :interaction_keepers
  end
end
