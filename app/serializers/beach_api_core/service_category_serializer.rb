module BeachApiCore
  class ServiceCategorySerializer < ActiveModel::Serializer
    include BeachApiCore::Concerns::DocIdAbsSerializerConcern

    attributes :id, :name
    has_many :services
  end
end