module BeachApiCore
  class InteractionKeeperSerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern

    attributes :id, :keeper_type, :keeper_id
  end
end
