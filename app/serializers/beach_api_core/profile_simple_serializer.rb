module BeachApiCore
  class ProfileSimpleSerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern

    attributes :id, :first_name, :last_name
  end
end
