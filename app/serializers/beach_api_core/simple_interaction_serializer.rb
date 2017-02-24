module BeachApiCore
  class SimpleInteractionSerializer < ActiveModel::Serializer
    attributes :id, :keeper_type, :keeper_id, :kind, :created_at
    belongs_to :user
  end
end
