module BeachApiCore
  class InteractionSerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern

    attributes :id, :created_at, :kind
    belongs_to :user
    has_many :assets
    has_many :interaction_attributes
    has_many :interaction_keepers
  end
end
