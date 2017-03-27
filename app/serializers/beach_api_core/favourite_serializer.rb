module BeachApiCore
  class FavouriteSerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern
    acts_as_abs_doc_id(:id, :favouritable_id)

    attributes :id, :favouritable_id, :favouritable_type
  end
end