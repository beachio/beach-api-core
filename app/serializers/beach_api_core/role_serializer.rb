module BeachApiCore
  class RoleSerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern

    attributes :id, :name
  end
end
