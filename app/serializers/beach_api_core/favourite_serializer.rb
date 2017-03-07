module BeachApiCore
  class FavouriteSerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern

    attributes :id, :favouritable_id, :favouritable_type
  end
end