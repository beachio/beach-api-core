module BeachApiCore
  class InteractionSerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern

    attributes :id, :created_at, :keeper_type, :keeper_id, :kind
    belongs_to :user
    has_many :attachments
    has_many :interaction_attributes
  end
end
