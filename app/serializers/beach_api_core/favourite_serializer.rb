module BeachApiCore
  class FavouriteSerializer < ActiveModel::Serializer
    attributes :id, :favouritable_id, :favouritable_type
  end
end