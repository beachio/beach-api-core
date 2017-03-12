module BeachApiCore
  class SimpleInteractionSerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern

    attributes :id, :kind, :created_at
    belongs_to :user
    has_many :interaction_keepers
  end
end
