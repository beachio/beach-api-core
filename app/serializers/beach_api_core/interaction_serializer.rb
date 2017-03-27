module BeachApiCore
  class InteractionSerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern
    acts_as_abs_doc_id

    attributes :id, :created_at, :kind
    belongs_to :user
    has_many :assets
    has_many :interaction_attributes
    has_many :interaction_keepers
  end
end
