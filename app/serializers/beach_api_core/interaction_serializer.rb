module BeachApiCore
  class InteractionSerializer < ActiveModel::Serializer
    attributes :id, :created_at, :keeper_type, :keeper_id, :kind
    has_many :attachments
    has_many :interaction_attributes
  end
end
